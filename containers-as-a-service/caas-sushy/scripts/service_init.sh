#!/bin/bash

set -x

CONTAINER_NAME="sushy-tools"
CONTAINER_VOLUME_ROOT="/opt/service-containers/${CONTAINER_NAME}"
CONTAINER_IMAGE="quay.io/metal3-io/sushy-tools"
CONTAINER_RESOURCE_LIMITS="-m 1024m"
CONTAINER_VOLUME_MOUNTS='-v /opt/service-containers/sushy-tools/config:/etc/sushy -v /var/run/libvirt:/var/run/libvirt'
CONTAINER_COMMAND="sushy-emulator -i :: -p 8111 --config /etc/sushy/sushy-emulator.conf"

################################################################################### EXECUTION PREFLIGHT
## Ensure there is an action arguement
if [ -z "$1" ]; then
  echo "Need action arguement of 'start', 'restart', or 'stop'!"
  echo "${0} start|stop|restart"
  exit 1
fi

################################################################################### SERVICE ACTION SWITCH
case $1 in

  ################################################################################# RESTART/STOP SERVICE
  "restart" | "stop" | "start")
    echo "Stopping container services if running..."

    echo "Killing sushy-tools container..."
    /usr/bin/podman kill ${CONTAINER_NAME}

    echo "Removing sushy-tools container..."
    /usr/bin/podman rm -f -i ${CONTAINER_NAME}
    ;;

esac

case $1 in

  ################################################################################# RESTART/START SERVICE
  "restart" | "start")

    echo "Starting container services..."

    # Deploy sushy-tools container
    echo -e "Deploying sushy-tools...\n"
    podman run -dt \
    --net host --privileged \
    --name ${CONTAINER_NAME} \
    ${CONTAINER_RESOURCE_LIMITS} \
    ${CONTAINER_VOLUME_MOUNTS} \
    ${CONTAINER_IMAGE} \
    ${CONTAINER_COMMAND}

    ;;

esac