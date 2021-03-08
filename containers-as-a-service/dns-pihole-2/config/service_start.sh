#!/bin/bash

set -x

source /opt/service-containers/dns-pihole-2/config/service_vars.sh

/opt/service-containers/dns-pihole-2/config/service_stop.sh

sleep 3

echo "Starting container ${CONTAINER_NAME}..."
/usr/bin/podman run -d --name $CONTAINER_NAME \
  --network $NETWORK_NAME \
  --ip $IP_ADDRESS \
  $CONTAINER_PORTS \
  -v $VOLUME_MOUNT_ONE \
  -v $VOLUME_MOUNT_TWO \
  $CONTAINER_ENVS \
  $CONTAINER_SOURCE