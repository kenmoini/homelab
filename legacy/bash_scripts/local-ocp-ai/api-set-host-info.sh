#!/bin/bash

#set -x
#set -e

source ./cluster-vars.sh

HOSTS=$(curl -s -X GET "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/${CLUSTER_ID}/hosts" --header "Content-Type: application/json")

hostList="{\"hosts\": ["
compiledHostNames=""
compiledHostRoles=""

while read h; do
  reshapenHost=${h%??}
  searchStr='"inventory":"{"'
  replaceStr='"inventory":{"'

  reshapenHost=$(echo $reshapenHost | sed "s|$searchStr|$replaceStr|")
  hostList=("${hostList}${reshapenHost}},")
  HOST_ID=$(echo "${reshapenHost}}" | jq -r '.id')
  HOST_MAC_ADDRESS=$(echo "${reshapenHost}}" | jq -r '.inventory.interfaces[0].mac_address')
  if [[ ${HOST_MAC_ADDRESS: -1} = "1" ]]; then
    count=${HOST_MAC_ADDRESS: 15: 1}
    compiledHostNames="${compiledHostNames}{ \"id\": \"$HOST_ID\", \"hostname\": \"app-${count}\" },"
    compiledHostRoles="${compiledHostRoles}{ \"id\": \"$HOST_ID\", \"role\": \"worker\" },"
  fi
  if [[ ${HOST_MAC_ADDRESS: -1} = "0" ]]; then
    count=${HOST_MAC_ADDRESS: 15: 1}
    compiledHostNames="${compiledHostNames}{ \"id\": \"$HOST_ID\", \"hostname\": \"cp-${count}\" },"
    compiledHostRoles="${compiledHostRoles}{ \"id\": \"$HOST_ID\", \"role\": \"master\" },"
  fi

done < <(printf '%s' "${HOSTS}" | jq -r -c '.[] | {id: .id, inventory: .inventory}')
hostList="${hostList%?}]}"

generatePatchData() {
cat <<EOF
{
  "hosts_roles": [ ${compiledHostRoles%?} ],
  "hosts_names": [ ${compiledHostNames%?} ]
}
EOF
}

# Set the Hostnames and Host Roles
echo "Setting Host information..."
SET_HOST_INFO_REQ=$(curl \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --request PATCH \
  --data "$(generatePatchData)" \
"http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID")