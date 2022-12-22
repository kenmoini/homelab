#!/bin/bash

set -x

CONTAINER_NAME="squid-proxy"
CONTAINER_VOLUME_ROOT="/opt/service-containers/${CONTAINER_NAME}"
CONTAINER_IMAGE="quay.io/kenmoini/squid-proxy:latest"
CONTAINER_RESOURCE_LIMITS="-m 1024m"
CONTAINER_NETWORK_NAME="lanBridge"
CONTAINER_IP_ADDRESS="192.168.42.31"
CONTAINER_PORTS="-p 3128"
CONTAINER_VOLUMES="-v ${CONTAINER_VOLUME_ROOT}/certs:/etc/squid/certs"

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

    echo "Killing ${CONTAINER_NAME} container..."
    /usr/bin/podman kill ${CONTAINER_NAME}

    echo "Removing ${CONTAINER_NAME} container..."
    /usr/bin/podman rm -f -i ${CONTAINER_NAME}
    ;;

esac

case $1 in

  ################################################################################# RESTART/START SERVICE
  "restart" | "start")

    echo "Pulling container image..."
    podman pull ${CONTAINER_IMAGE}

    echo "Starting container services..."

    # Deploy container
    echo -e "Deploying ${CONTAINER_NAME}...\n"
    podman run -dt \
    --network "${CONTAINER_NETWORK_NAME}" --ip "${CONTAINER_IP_ADDRESS}" ${CONTAINER_PORTS} \
    --name ${CONTAINER_NAME} \
    ${CONTAINER_RESOURCE_LIMITS} \
    ${CONTAINER_VOLUMES} \
    ${CONTAINER_IMAGE}

    ;;

esac