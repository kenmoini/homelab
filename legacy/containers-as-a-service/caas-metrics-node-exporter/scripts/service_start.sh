#!/bin/bash

set -x

source /opt/service-containers/metrics-node-exporter/scripts/service_vars.sh

/opt/service-containers/metrics-node-exporter/scripts/service_stop.sh

sleep 3

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name "${CONTAINER_NAME}" \
 --network "${NETWORK_NAME}" --pid="host" \
 --restart unless-stopped \
 -v /:/host:ro,rslave \
 $CONTAINER_PORTS \
 ${RESOURCE_LIMITS} \
 ${CONTAINER_SOURCE} \
 --path.rootfs=/host