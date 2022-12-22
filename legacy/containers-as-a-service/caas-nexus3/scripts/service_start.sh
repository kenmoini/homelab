#!/bin/bash

set -x

source /opt/service-containers/nexus3/scripts/service_vars.sh

${POD_VOLUME_ROOT}/scripts/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

rm nohup.out

/root/podmanRHRLogin.sh

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name "${CONTAINER_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" ${CONTAINER_PORTS} ${VOLUME_MOUNTS} ${RESOURCE_LIMITS} ${CONTAINER_IMAGE}