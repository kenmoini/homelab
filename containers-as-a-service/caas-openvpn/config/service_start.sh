#!/bin/bash

set -x

source /opt/service-containers/caas-openvpn/config/service_vars.sh

/opt/service-containers/caas-openvpn/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Enabling iptable_nat module..."
modprobe iptable_nat

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run --privileged \
 -d --name "${CONTAINER_NAME}" \
 --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" \
 -v ${OVPN_VOLUME_MOUNT} \
 $CONTAINER_PORTS \
 ${RESOURCE_LIMITS} \
 ${CONTAINER_SOURCE}