#!/bin/bash

POD_NAME="zerotier"
POD_NETWORK_NAME="lanBridge"
POD_IP_ADDRESS="192.168.42.23"
POD_PORTS="-p 4000/tcp -p 9993/udp -p 9993/tcp"
POD_VOLUME_ROOT="/opt/service-containers/${POD_NAME}"

RESOURCE_LIMITS="-m 2048m"

ZEROTIER_CONTROLLER_NAME="zerotier-controller"
ZEROTIER_UI_NAME="zerotier-ui"
ZEROTIER_CLIENT_NAME="zerotier-client"

ZEROTIER_CONTROLLER_CONTAINER_IMAGE="dec0dos/zerotier-controller:latest"
ZEROTIER_UI_CONTAINER_IMAGE="dec0dos/zero-ui:latest"
ZEROTIER_CLIENT_CONTAINER_IMAGE="zyclonite/zerotier:bridge"


################################################################################### EXECUTION PREFLIGHT
## Ensure there is an action arguement
if [ -z "$1" ]; then
  echo "Need action arguement of 'start', 'restart', or 'stop'!"
  echo "${0} start|stop|restart"
  exit 1
fi

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${POD_NETWORK_NAME}/${POD_IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi


################################################################################### SERVICE ACTION SWITCH
case $1 in

  ################################################################################# RESTART/STOP SERVICE
  "restart" | "stop" | "start")
    echo "Stopping container services if running..."

    echo "Killing Zerotier containers and pod..."
    /usr/bin/podman kill ${ZEROTIER_CONTROLLER_NAME}
    /usr/bin/podman kill ${ZEROTIER_UI_NAME}
    /usr/bin/podman kill ${ZEROTIER_CLIENT_NAME}
    /usr/bin/podman pod kill ${POD_NAME}

    echo "Removing Zerotier containers and pod..."
    /usr/bin/podman rm -f -i ${ZEROTIER_CONTROLLER_NAME}
    /usr/bin/podman rm -f -i ${ZEROTIER_UI_NAME}
    /usr/bin/podman rm -f -i ${ZEROTIER_CLIENT_NAME}
    /usr/bin/podman pod rm -f -i ${POD_NAME}
    ;;

esac

case $1 in

  ################################################################################# RESTART/START SERVICE
  "restart" | "start")
    echo -e "Deploying Pod...\n"
    podman pod create --name "${POD_NAME}" --network "${POD_NETWORK_NAME}" --ip "${POD_IP_ADDRESS}" ${POD_PORTS}

    sleep 3

    echo "Starting container services..."

    # Deploy Zerotier Controller
    echo -e "Deploying Zerotier Controller...\n"
    podman run -dt --name ${ZEROTIER_CONTROLLER_NAME} \
    --pod ${POD_NAME} \
    -v ${POD_VOLUME_ROOT}/volumes/controller_data:/var/lib/zerotier-one \
    ${RESOURCE_LIMITS} \
    ${ZEROTIER_CONTROLLER_CONTAINER_IMAGE}

    sleep 5

    # Deploy Zerotier UI
    echo -e "Deploying Zerotier UI...\n"
    podman run -dt --name ${ZEROTIER_UI_NAME} \
    --pod ${POD_NAME} \
    -v ${POD_VOLUME_ROOT}/volumes/controller_data:/var/lib/zerotier-one -v ${POD_VOLUME_ROOT}/volumes/zero-ui_data:/app/backend/data \
    -e ZU_CONTROLLER_ENDPOINT=http://localhost:9993/ -e ZU_SECURE_HEADERS=true -e ZU_DEFAULT_USERNAME=admin -e ZU_DEFAULT_PASSWORD="$(cat ${POD_VOLUME_ROOT}/secrets/admin.pass)" \
    ${RESOURCE_LIMITS} \
    ${ZEROTIER_UI_CONTAINER_IMAGE}

    sleep 5
    #
    echo -e "Deploying Zerotier Client...\n"
    podman run -dt --name ${ZEROTIER_CLIENT_NAME} \
    --net host \
    --device=/dev/net/tun \
    --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_ADMIN \
    -v ${POD_VOLUME_ROOT}/volumes/zerotier-client:/var/lib/zerotier-one \
    ${RESOURCE_LIMITS} \
    ${ZEROTIER_CLIENT_CONTAINER_IMAGE}

    ;;

esac