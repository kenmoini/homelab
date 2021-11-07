#!/bin/bash

set -x

source /opt/caas/nextcloud/config/service_vars.sh

echo "Killing container..."
/usr/bin/podman pod kill $POD_NAME

echo "Removing container..."
/usr/bin/podman pod rm -f -i $POD_NAME