#!/bin/bash

#set -x
#set -e

source ./cluster-vars.sh

# Start the Install
echo "Starting OpenShift Installation..."
START_INSTALLATION_REQ=$(curl \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --request POST \
"http://$ASSISTED_SERVICE_IP:$ASSISTED_SERVICE_PORT/api/assisted-install/v1/clusters/$CLUSTER_ID/actions/install")
