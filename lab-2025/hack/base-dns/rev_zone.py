import yaml
import argparse
import datetime
import requests
import json
import ipaddress

# =============================================
# Handle command line arguments
parser = argparse.ArgumentParser(
                    prog='sync.py',
                    description='Takes in a GoZones file and syncs to PowerDNS via the API',
                    epilog='Use at your own risk')
parser.add_argument('-f', '--file', help='GoZones file to sync', required=True)
parser.add_argument('-s', '--server', help='PowerDNS Server API eg http://127.0.0.1:8081', required=True)
parser.add_argument('-k', '--key', help='PowerDNS API Key', required=True)
args = parser.parse_args()

# =============================================
# Set request headers
headers = {
    'X-API-Key': args.key,
    'Content-Type': 'application/json'
}

# =============================================
# Perform an API test
response = requests.get(args.server + '/api/v1/servers/localhost', headers=headers)
if response.status_code != 200:
    print('Error: Unable to connect to PowerDNS API')
    exit()

# =============================================
def addLastDot(name):
    if name[-1] != '.':
        name = name + '.'
    return name

# =============================================
# PTR Records
def processPTRRecords(input, defaultTTL):
    ptrRecords = []
    anchoredPTRRecords = {}
    ptrRRSets = []
    anchoredTTLS = {}

    for record in input['records']['A']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredARecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['A']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredARecords[name].append({
            'content': stripCIDR(record['value']),
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, aRecords in anchoredARecords.items():
        recordTTL = anchoredTTLS[name]
        aRRSets.append({
            'name': name,
            'type': 'A',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': aRecords
        })

    return aRRSets

def ip2bin(ip):
    octets = map(int, ip.split('/')[0].split('.')) # '1.2.3.4'=>[1, 2, 3, 4]
    binary = '{0:08b}{1:08b}{2:08b}{3:08b}'.format(*octets)
    range = int(ip.split('/')[1]) if '/' in ip else None
    return binary[:range] if range else binary

def splitV4AddressIntoParts(ipAddress):
    addressArray = ipAddress.split('/')
    address = addressArray[0]
    cidr = addressArray[1]




# =============================================
with open(args.file, "r") as stream:
    try:
        yaml_data = yaml.safe_load(stream)
        # Loop through the YAML file .dns.zones entries
        detectedReverseZones = {}
        ptrRecords = []
        recordSets = []
        anchoredTTLs = {}
        print('=====================================')
        print('Processing zones...')
        for zone in yaml_data['dns']['zones']:
            # Check if the zone exists
            #print(zone)
            print(" - Checking for reverse records in Zone: " + zone['zone'])
            if 'A' in zone['records'].keys():
                # Loop through the A records
                for record in zone['records']['A']:
                    #print(record)
                    if '/' in record['value']:
                        ipPart = record['value'].split('/')[0]
                        cidrPart = int(record['value'].split('/')[1])
                        ipNetwork = ipaddress.ip_network(record['value'], False)
                        ipAddress = ipaddress.ip_address(ipPart)

                        ipArray = ipPart.split('.')
                        if ipArray[0] == '10':
                            reverseZone = addLastDot('10.in-addr.arpa')
                            recordKey = addLastDot(str(ipArray[3]) + '.' + str(ipArray[2]) + '.' + str(ipArray[1]) + '.' + '10.in-addr.arpa')
                        elif ipArray[0] == '172':
                            if int(ipArray[1]) >= 16 and int(ipArray[1]) <= 31:
                                reverseZone = addLastDot(ipArray[1] + '.172.in-addr.arpa')
                                recordKey = addLastDot(str(ipArray[3]) + '.' + str(ipArray[2]) + '.' + ipArray[1] + '.172.in-addr.arpa')
                        elif ipArray[0] == '192' and ipArray[1] == '168':
                            reverseZone = addLastDot('168.192.in-addr.arpa')
                            recordKey = addLastDot(str(ipArray[3]) + '.' + str(ipArray[2]) + '.' + '168.192.in-addr.arpa')
                        elif ipArray[0] == '100':
                            if int(ipArray[1]) >= 64 and int(ipArray[1]) <= 127:
                                reverseZone = addLastDot(ipArray[1] + '.100.in-addr.arpa')
                                recordKey = addLastDot(str(ipArray[3]) + '.' + str(ipArray[2]) + '.' + ipArray[1] + '.100.in-addr.arpa')

                        if reverseZone not in detectedReverseZones.keys():
                            detectedReverseZones[reverseZone] = {}

                        # Check if the record exists
                        if recordKey not in detectedReverseZones[reverseZone].keys():
                            detectedReverseZones[reverseZone][recordKey] = addLastDot(record['name'] + '.' + zone['zone'])

                        if "ttl" in record.keys():
                            anchoredTTLs[recordKey] = str(record['ttl'])
                        else:
                            anchoredTTLs[recordKey] = zone['default_ttl']


        #print(json.dumps(detectedReverseZones, indent=2))
        print('=====================================')
        print('Processing reverse zones...')
        for reverseZone in detectedReverseZones:
            print(' - Processing reverse zone: ' + reverseZone)
            # Check if the zone exists
            print(" - Checking for Zone: " + reverseZone)
            response = requests.get(args.server + '/api/v1/servers/localhost/zones/' + reverseZone, headers=headers)
            if response.status_code == 200:
                # Zone exists, update it
                print(' - Zone exists: ' + reverseZone)
                #print(response.json())
            elif response.status_code == 404:
                # Zone does not exist, create it
                print(' - Creating zone: ' + reverseZone)
                # Create form body
                form_body = {
                    'name': addLastDot(reverseZone),
                    'kind': 'Native',
                    'type': 'Zone',
                    'dnssec': False
                }
                response = requests.post(args.server + '/api/v1/servers/localhost/zones', headers=headers, json=form_body)
            else:
                # Unknown error
                print('Error while checking for zone: ' + reverseZone - ' - ' + response.json())

            # Loop through the records
            for record, setting in detectedReverseZones[reverseZone].items():
                recordSets.append({
                    'name': record,
                    'type': 'PTR',
                    'ttl': anchoredTTLs[record],
                    'changetype': 'REPLACE',
                    'records': [{
                        'content': setting,
                        'disabled': False
                    }]
                })

            # Send the request
            form_body = {
                'rrsets': recordSets
            }

            response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + reverseZone, headers=headers, json=form_body)
            if response.status_code == 204:
                print('   - PTR Records updated')
            else:
                print(response.json())

    except yaml.YAMLError as exc:
        print(exc)