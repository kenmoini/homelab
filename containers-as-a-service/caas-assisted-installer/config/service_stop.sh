#!/bin/bash

set -x

source /opt/service-containers/caas-assisted-installer/config/service_vars.sh

echo "Killing container..."
/usr/bin/podman pod kill $CONTAINER_NAME

echo "Removing container..."
/usr/bin/podman pod rm $CONTAINER_NAME -f -i