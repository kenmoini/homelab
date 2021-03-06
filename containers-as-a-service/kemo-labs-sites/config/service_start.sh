#!/bin/bash

set -x

source /opt/service-containers/kemo-labs-sites/config/service_vars.sh

/opt/service-containers/kemo-labs-sites/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run --privileged --user root \
 -d --name "${CONTAINER_NAME}" \
 --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" \
 $CONTAINER_PORTS \
 ${RESOURCE_LIMITS} \
 ${VOLUME_MOUNTS} \
 ${CONTAINER_SOURCE}