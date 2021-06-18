#!/bin/bash

set -e
set -x

ASSISTED_SERVICE_IP="assisted-installer.kemo.labs"
ASSISTED_SERVICE_PORT="8090"

CLUSTER_VERSION="4.7.9"
CLUSTER_IMAGE="quay.io/openshift-release-dev/ocp-release:4.7.9-x86_64"
CLUSTER_NAME="core-ocp"
CLUSTER_DOMAIN="kemo.labs"
CLUSTER_NET_TYPE="Calico"
CLUSTER_CIDR_NET="10.128.0.0/14"
CLUSTER_CIDR_SVC="172.30.0.0/16"
CLUSTER_HOST_PFX="24"
CLUSTER_WORKER_HT="Enabled"
CLUSTER_WORKER_COUNT="0"
CLUSTER_MASTER_HT="Enabled"
CLUSTER_MASTER_COUNT="0"

CLUSTER_SSHKEY=$(cat /home/kemo/.ssh/MasterKemoKey.pub-ah | cut -d ' ' -f 1,2)
TOKEN=""

PULL_SECRET=$(cat pull-secret.txt | jq -R .)

# Create deployment file
cat << EOF > ./deployment.json
{
  "kind": "Cluster",
  "name": "$CLUSTER_NAME",
  "openshift_version": "$CLUSTER_VERSION",
  "ocp_release_image": "$CLUSTER_IMAGE",
  "base_dns_domain": "$CLUSTER_DOMAIN",
  "hyperthreading": "all",
  "cluster_network_cidr": "$CLUSTER_CIDR_NET",
  "cluster_network_host_prefix": $CLUSTER_HOST_PFX,
  "service_network_cidr": "$CLUSTER_CIDR_SVC",
  "user_managed_networking": true,
  "vip_dhcp_allocation": false,
  "high_availability_mode": "Full",
  "host_networks": [],
  "hosts": [],
  "ssh_public_key": "$CLUSTER_SSHKEY",
  "pull_secret": $PULL_SECRET
}
EOF

CREATE_CLUSTER_CURL=$(curl -s -X POST "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/" -d @./deployment.json --header "Content-Type: application/json")
CLUSTER_ID=$(echo $CREATE_CLUSTER_CURL | jq -r '.id')

if [[ $CLUSTER_NET_TYPE = "Calico" ]]; then
  curl \
    --header "Content-Type: application/json" \
    --request PATCH \
    --data '"{\"networking\":{\"networkType\":\"Calico\"}}"' \
  "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/install-config"
fi

# Generate ISO Parameters
cat << EOF > ./iso-params.json
{
  "ssh_public_key": "$CLUSTER_SSHKEY",
  "pull_secret": $PULL_SECRET
}
EOF

# Have the AI Service build the ISO
curl -s -X POST "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/downloads/image" -d @iso-params.json --header "Content-Type: application/json" | jq .

sleep 15

# Download the ISO
curl -L "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/downloads/image" -o ai-liveiso-$CLUSTER_ID.iso