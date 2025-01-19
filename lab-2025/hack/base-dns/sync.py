import yaml
import argparse
import datetime
import requests

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
#print(response.json())

# =============================================
# Functions
def addLastDot(name):
    if name[-1] != '.':
        name = name + '.'
    return name

def removeLastDot(name):
    if name[-1] == '.':
        name = name[:-1]
    return name

def stripCIDR(name):
    if '/' in name:
        name = name.split('/')[0]
    return name

def wrapWithDoubleQuotes(name):
    if name[0] != '"':
        name = '"' + name
    if name[-1] != '"':
        name = name + '"'
    return name

# =============================================
# NS Records
def processNSRecords(input, defaultTTL):
    anchoredTTLS = {}
    nsRecords = []
    anchoredNSRecords = {}
    nsRRSets = []
    if 'NS' not in input['records'].keys():
        return nsRRSets

    for ns in input['records']['NS']:
        if ns['anchor'] != "@":
            anchor = addLastDot(ns['anchor'])
        else:
            anchor = addLastDot(input['zone'])
        anchoredNSRecords[anchor] = []

        if "ttl" in ns.keys():
            anchoredTTLS[anchor] = str(ns['ttl'])
        else:
            anchoredTTLS[anchor] = defaultTTL

    for ns in input['records']['NS']:
        if ns['anchor'] != "@":
            anchor = addLastDot(ns['anchor'])
        else:
            anchor = addLastDot(input['zone'])

        anchoredNSRecords[anchor].append({
            'content': addLastDot(ns['name'] + '.' + ns['domain']),
            'disabled': False
        })

    # Loop through the anchored NS Records
    for anchor, nsRecords in anchoredNSRecords.items():
        recordTTL = anchoredTTLS[anchor]
        nsRRSets.append({
            'name': anchor,
            'type': 'NS',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': nsRecords
        })
    return nsRRSets

# =============================================
# A Records
def processARecords(input, defaultTTL):
    aRecords = []
    anchoredARecords = {}
    aRRSets = []
    anchoredTTLS = {}
    if 'A' not in input['records'].keys():
        return aRRSets

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

# =============================================
# AAAA Records
def processAAAARecords(input, defaultTTL):
    aaaaRecords = []
    anchoredAAAARecords = {}
    aaaaRRSets = []
    anchoredTTLS = {}
    if 'AAAA' not in input['records'].keys():
        return aaaaRRSets

    for record in input['records']['AAAA']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredAAAARecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['AAAA']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredAAAARecords[name].append({
            'content': stripCIDR(record['value']),
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, aaaaRecords in anchoredAAAARecords.items():
        recordTTL = anchoredTTLS[name]
        aaaaRRSets.append({
            'name': name,
            'type': 'AAAA',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': aaaaRecords
        })

    return aaaaRRSets

# =============================================
# CNAME Records
def processCNAMERecords(input, defaultTTL):
    cnameRecords = []
    anchoredCNAMERecords = {}
    cnameRRSets = []
    anchoredTTLS = {}
    if 'CNAME' not in input['records'].keys():
        return cnameRRSets

    for record in input['records']['CNAME']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredCNAMERecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['CNAME']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredCNAMERecords[name].append({
            'content': record['value'],
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, cnameRecords in anchoredCNAMERecords.items():
        recordTTL = anchoredTTLS[name]
        cnameRRSets.append({
            'name': name,
            'type': 'CNAME',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': cnameRecords
        })

    return cnameRRSets

# =============================================
# TXT Records
def processTXTRecords(input, defaultTTL):
    txtRecords = []
    anchoredTXTRecords = {}
    txtRRSets = []
    anchoredTTLS = {}
    if 'TXT' not in input['records'].keys():
        return txtRRSets

    for record in input['records']['TXT']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredTXTRecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['TXT']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredTXTRecords[name].append({
            'content': wrapWithDoubleQuotes(record['value']),
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, txtRecords in anchoredTXTRecords.items():
        recordTTL = anchoredTTLS[name]
        txtRRSets.append({
            'name': name,
            'type': 'TXT',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': txtRecords
        })

    return txtRRSets

# =============================================
# SRV Records
def processSRVRecords(input, defaultTTL):
    srvRecords = []
    anchoredSRVRecords = {}
    srvRRSets = []
    anchoredTTLS = {}
    if 'SRV' not in input['records'].keys():
        return srvRRSets

    for record in input['records']['SRV']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredSRVRecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['SRV']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredSRVRecords[name].append({
            'content': str(record['priority']) + ' ' + str(record['weight']) + ' ' + str(record['port']) + ' ' + addLastDot(record['value']),
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, srvRecords in anchoredSRVRecords.items():
        recordTTL = anchoredTTLS[name]
        srvRRSets.append({
            'name': name,
            'type': 'SRV',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': srvRecords
        })

    return srvRRSets

# =============================================
# MX Records
def processMXRecords(input, defaultTTL):
    mxRecords = []
    anchoredMXRecords = {}
    mxRRSets = []
    anchoredTTLS = {}
    if 'MX' not in input['records'].keys():
        return mxRRSets

    for record in input['records']['MX']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredMXRecords[name] = []

        if "ttl" in record.keys():
            anchoredTTLS[name] = str(record['ttl'])
        else:
            anchoredTTLS[name] = defaultTTL
    for record in input['records']['MX']:
        if record['name'] != "@":
            name = addLastDot(record['name'] + '.' + zone['zone'])
        else:
            name = addLastDot(input['zone'])
        anchoredMXRecords[name].append({
            'content': str(record['priority']) + ' ' + addLastDot(record['value']),
            'disabled': False
        })

    # Loop through the anchored A Records
    for name, mxRecords in anchoredMXRecords.items():
        recordTTL = anchoredTTLS[name]
        mxRRSets.append({
            'name': name,
            'type': 'MX',
            'ttl': recordTTL,
            'changetype': 'REPLACE',
            'records': mxRecords
        })

    return mxRRSets

# =============================================
# Open the GoZones file
with open(args.file, "r") as stream:
    try:
        yaml_data = yaml.safe_load(stream)
        # Loop through the YAML file .dns.zones entries
        for zone in yaml_data['dns']['zones']:
            #print(zone)
            # Check if the zone exists
            print('=====================================')
            print("Checking for Zone: " + zone['zone'])
            response = requests.get(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers)
            if response.status_code == 200:
                # Zone exists, update it
                print(' - Zone exists: ' + zone['name'])
                #print(response.json())
            elif response.status_code == 404:
                # Zone does not exist, create it
                print(' - Creating zone: ' + zone['name'])
                # Create form body
                form_body = {
                    'name': addLastDot(zone['zone']),
                    'kind': 'Native',
                    'type': 'Zone',
                    'dnssec': False
                }
                response = requests.post(args.server + '/api/v1/servers/localhost/zones', headers=headers, json=form_body)
                #print(response.json())
            else:
                # Unknown error
                print('Error while checking for zone: ' + zone['name'] - ' - ' + response.json())

            # =============================================
            # Set the SOA Record
            print(' - Setting SOA Record')
            defaultTTL = str(zone['default_ttl'])
            recordDate = datetime.datetime.now().strftime("%Y%m%d%H")
            form_body = {
                'rrsets': [
                    {
                        'name': addLastDot(zone['zone']),
                        'type': 'SOA',
                        'ttl': defaultTTL,
                        'changetype': 'REPLACE',
                        'records': [
                            {
                                'content': addLastDot(zone['primary_dns_server']) + ' admin.' + addLastDot(zone['zone']) + ' ' + recordDate + ' 10800 ' + defaultTTL +' 604800 ' + defaultTTL,
                                'disabled': False
                            }
                        ]
                    }
                ]
            }
            response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
            if response.status_code == 204:
                print('   - SOA Record updated')

            # =============================================
            # Set the NS Records
            print(' - Setting NS Records')
            nsRRSets = processNSRecords(zone, defaultTTL)
            
            if len(nsRRSets) == 0:
                print('   - No NS Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': nsRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - NS Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the A Records
            print(' - Setting A Records')
            aRRSets = processARecords(zone, defaultTTL)

            if len(aRRSets) == 0:
                print('   - No A Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': aRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - A Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the AAAA Records
            print(' - Setting AAAA Records')
            aaaaRRSets = processAAAARecords(zone, defaultTTL)

            if len(aaaaRRSets) == 0:
                print('   - No AAAA Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': aaaaRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - AAAA Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the CNAME Records
            print(' - Setting CNAME Records')
            cnameRRSets = processCNAMERecords(zone, defaultTTL)

            if len(cnameRRSets) == 0:
                print('   - No CNAME Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': cnameRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - CNAME Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the TXT Records
            print(' - Setting TXT Records')
            txtRRSets = processTXTRecords(zone, defaultTTL)

            if len(txtRRSets) == 0:
                print('   - No TXT Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': txtRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - TXT Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the SRV Records
            print(' - Setting SRV Records')
            srvRRSets = processSRVRecords(zone, defaultTTL)

            if len(srvRRSets) == 0:
                print('   - No SRV Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': srvRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - SRV Records updated')
                else:
                    print(response.json())

            # =============================================
            # Set the MX Records
            print(' - Setting MX Records')
            mxRRSets = processMXRecords(zone, defaultTTL)

            if len(mxRRSets) == 0:
                print('   - No MX Records to update')
            else:
                # Send the request
                form_body = {
                    'rrsets': mxRRSets
                }

                response = requests.patch(args.server + '/api/v1/servers/localhost/zones/' + zone['zone'], headers=headers, json=form_body)
                if response.status_code == 204:
                    print('   - MX Records updated')
                else:
                    print(response.json())

    except yaml.YAMLError as exc:
        print(exc)