#!/bin/bash

set -x

source /opt/caas/plex/config/service_vars.sh

/opt/caas/plex/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run --privileged \
 -d --name "${CONTAINER_NAME}" \
 --network "${NETWORK_NAME}" \
 --ip "${IP_ADDRESS}" \
 ${CONTAINER_PORTS} \
 ${VOLUME_MOUNTS} \
 ${RESOURCE_LIMITS} \
-e TZ="America/New_York" \
-e ADVERTISE_IP="http://0.0.0.0:32400/" \
-h "plex" \
 ${CONTAINER_SOURCE}