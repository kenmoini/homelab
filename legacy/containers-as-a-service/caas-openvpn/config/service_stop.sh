#!/bin/bash

set -x

source /opt/service-containers/caas-openvpn/config/service_vars.sh

echo "Killing container..."
/usr/bin/podman kill $CONTAINER_NAME

echo "Removing container..."
/usr/bin/podman rm $CONTAINER_NAME -f -i