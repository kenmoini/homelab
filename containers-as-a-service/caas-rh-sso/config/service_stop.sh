#!/bin/bash

set -x

source /opt/service-containers/caas-rh-sso/config/service_vars.sh

echo "Killing container..."
/usr/bin/podman pod kill $POD_NAME

echo "Removing container..."
/usr/bin/podman pod rm $POD_NAME -f -i