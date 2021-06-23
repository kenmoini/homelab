#!/bin/bash

set -e
#set -x

source ./cluster-vars.sh

if [ -f ".cluster.nfo" ]; then
  echo -e "Cluster NFO found, skipping new AI Cluster creation...\n"
else
  # Create deployment file
  echo -e "Creating Deployment JSON...\n"
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

  echo -e "Creating cluster in OpenShift Assisted Installer Service...\n"
  CREATE_CLUSTER_CURL=$(curl -s -X POST "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/" -d @./deployment.json --header "Content-Type: application/json")
  CLUSTER_ID=$(echo $CREATE_CLUSTER_CURL | jq -r '.id')
  echo -e "Setting Cluster ID: ${CLUSTER_ID}...\n"
  echo ${CLUSTER_ID} > .cluster.nfo

  if [[ $CLUSTER_NET_TYPE = "Calico" ]]; then
    echo -e "Patching cluster install-config for Calico networking..."
    curl \
      --header "Content-Type: application/json" \
      --request PATCH \
      --data '"{\"networking\":{\"networkType\":\"Calico\"}}"' \
    "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/install-config"
  fi

fi

if [ -f "ai-liveiso-$CLUSTER_ID.iso" ]; then
  echo -e "Cluster ISO found, skipping ISO generation...\n"
else
  # Generate ISO Parameters
  echo -e "Generating ISO Params JSON..."
cat << EOF > ./iso-params.json
{
  "ssh_public_key": "$CLUSTER_SSHKEY",
  "pull_secret": $PULL_SECRET
}
EOF

  # Have the AI Service build the ISO
  echo -e "Building ISO...\n"
  curl -s -X POST "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/downloads/image" -d @iso-params.json --header "Content-Type: application/json" | jq .

  echo -e "Waiting 15s for ISO to build...\n"
  sleep 15

  # Download the ISO
  echo -e "Downloading ISO locally...\n"
  curl -L "http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/downloads/image" -o ai-liveiso-$CLUSTER_ID.iso
fi

# Set Cluster VIPs if needed
if [[ ! $CLUSTER_API_VIP = "auto" ]] || [[ ! $CLUSTER_LOAD_BALANCER_VIP = "auto" ]]; then
  echo -e "\Setting Cluster VIPs...\n"
  sleep 3
  source ./api-set-vips.sh
  sleep 3
fi

# Provision Infrastructure
if [[ $INFRASTRUCTURE_LAYER = "libvirt" ]]; then
  echo -e "\nStarting Libvirt Infrastructure deployment...\n"
  source ./libvirt-create-vm.sh
fi

# Provision Infrastructure
if [[ $INFRASTRUCTURE_LAYER = "libvirt-local" ]]; then
  echo -e "\nStarting Libvirt Local Infrastructure deployment...\n"
  source ./libvirt-local-create-vm.sh
fi

if [[ $CLUSTER_TYPE = "Standard" ]]; then
  echo -e "\nSetting HA Cluster Host Names and Roles...sleeping for 60s...\n"
  # Sleep 60s so the infra has time to come up and check in
  sleep 60
  source ./api-set-host-info.sh
fi