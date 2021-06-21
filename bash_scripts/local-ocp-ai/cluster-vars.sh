#!/bin/bash

#set -x
set -e

ASSISTED_SERVICE_IP="assisted-installer.kemo.labs"
ASSISTED_SERVICE_PORT="8090"

# CLUSTER_TYPE can be: Standard (HA CP+App Nodes), SNO (Single Node OpenShift)
CLUSTER_TYPE="Standard"

# CLUSTER_NET_TYPE = Default, or Calico
CLUSTER_NET_TYPE="Default"

CLUSTER_NAME="core-ocp"
CLUSTER_DOMAIN="kemo.labs"

CLUSTER_CIDR_NET="10.128.0.0/14"
CLUSTER_CIDR_SVC="172.30.0.0/16"
CLUSTER_HOST_PFX="24"
CLUSTER_APP_NODE_HT="Enabled"
CLUSTER_APP_NODE_COUNT="2"
CLUSTER_APP_NODE_CPU_SOCKETS="1"
CLUSTER_APP_NODE_CPU_CORES="4"
CLUSTER_APP_NODE_RAM_GB="8"
CLUSTER_APP_NODE_DISK_GB="60"
CLUSTER_CONTROL_PLANE_HT="Enabled"
CLUSTER_CONTROL_PLANE_COUNT="3"
CLUSTER_CONTROL_PLANE_CPU_SOCKETS="1"
CLUSTER_CONTROL_PLANE_CPU_CORES="4"
CLUSTER_CONTROL_PLANE_RAM_GB="8"
CLUSTER_CONTROL_PLANE_DISK_GB="60"

# INFRASTRUCTURE_LAYER Options: (blank, no infrastructure created), libvirt
INFRASTRUCTURE_LAYER="libvirt"

CLUSTER_SSHKEY=$(cat ~/.ssh/MasterKemoKey.pub-ah | cut -d ' ' -f 1,2)
TOKEN=""

PULL_SECRET=$(cat pull-secret.txt | jq -R .)

if [[ $CLUSTER_TYPE = "Standard" ]]; then
  CLUSTER_VERSION="4.7.9"
  CLUSTER_IMAGE="quay.io/openshift-release-dev/ocp-release:4.7.9-x86_64"
fi

if [[ $CLUSTER_TYPE = "SNO" ]]; then
  CLUSTER_VERSION="4.8.0-rc.0"
  CLUSTER_IMAGE="quay.io/openshift-release-dev/ocp-release:4.8.0-rc.0-x86_64"
fi