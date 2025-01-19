
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