#!/bin/bash

#set -x
#set -e

source ./cluster-vars.sh

vipDHCPEnabled="false"

if [[ ! $CLUSTER_API_VIP = "auto" ]] || [[ ! $CLUSTER_MACHINE_CIDR = "auto" ]] || [[ ! $CLUSTER_LOAD_BALANCER_VIP = "auto" ]]; then
  vipDHCPEnabled="true"
  vipAPI=$CLUSTER_API_VIP
  vipIngress=$CLUSTER_LOAD_BALANCER_VIP
  machineNetwork="$CLUSTER_MACHINE_CIDR"
fi

generatePatchData() {
cat <<EOF
{
  "vip_dhcp_allocation": $vipDHCPEnabled,
  "api_vip": "$vipAPI",
  "ingress_vip": "$vipIngress",
  "user_managed_networking": false
}
EOF
}

if [[ $vipDHCPEnabled = "true" ]]; then
  # Set the Hostnames and Host Roles
  echo "Setting API and Ingress VIPs..."

  SET_HOST_INFO_REQ=$(curl \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --request PATCH \
    --data "$(generatePatchData)" \
  "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID")
fi