#!/bin/bash

set -x

SOURCE_ROOT=/home/kemo/homelab/containers-as-a-service/quay-registry

source ${SOURCE_ROOT}/config/service_vars.sh

echo "Killing container..."
/usr/bin/podman pod kill $POD_NAME

echo "Removing container..."
/usr/bin/podman pod rm $POD_NAME -f -i