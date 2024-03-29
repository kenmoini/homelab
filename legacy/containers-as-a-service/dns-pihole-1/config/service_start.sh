#!/bin/bash

set -x

source /opt/service-containers/dns-pihole-1/config/service_vars.sh

/opt/service-containers/dns-pihole-1/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name $CONTAINER_NAME \
  --privileged \
  --network $NETWORK_NAME \
  --ip $IP_ADDRESS \
  $CONTAINER_PORTS \
  -v $VOLUME_MOUNT_ONE \
  -v $VOLUME_MOUNT_TWO \
  $CONTAINER_ENVS \
  ${RESOURCE_LIMITS} \
  $CONTAINER_SOURCE