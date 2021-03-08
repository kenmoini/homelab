#!/bin/bash

set -x

source /opt/service-containers/dns-core-1/config/service_vars.sh

/opt/service-containers/dns-core-1/config/service_stop.sh

pause 3

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name "${CONTAINER_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" -p "${CONTAINER_PORT}" -v ${VOLUME_MOUNT_ONE} ${CONTAINER_SOURCE}