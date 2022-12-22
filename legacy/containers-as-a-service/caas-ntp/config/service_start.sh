#!/bin/bash

set -x

source /opt/service-containers/caas-ntp/config/service_vars.sh

/opt/service-containers/caas-ntp/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name "${CONTAINER_NAME}" \
 --cap-add SYS_TIME \
 --cap-add NET_BIND_SERVICE \
 --network "${NETWORK_NAME}" \
 --ip "${IP_ADDRESS}" \
 ${CONTAINER_PORTS} \
 ${CONTAINER_ENV_VARS} \
 ${RESOURCE_LIMITS} \
 ${CONTAINER_SOURCE}