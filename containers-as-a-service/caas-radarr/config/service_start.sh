#!/bin/bash

set -x

source /opt/caas/radarr/config/service_vars.sh

/opt/caas/radarr/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run \
    -d --name "${CONTAINER_NAME}" \
    --network "${NETWORK_NAME}" \
    --ip "${IP_ADDRESS}" \
    ${CONTAINER_PORTS} \
    ${RESOURCE_LIMITS} \
    -e TZ="America/New_York" \
    -e PUID=1420 \
    -e PGID=1420 \
    -v "/mnt/primary/nfs/media/Movies:/movies" \
    -v /opt/caas/radarr/volumes/config:/config \
    --restart unless-stopped \
    -h "radarr" \
    ${CONTAINER_SOURCE}
  