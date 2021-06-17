#!/bin/bash

set -x

source /opt/service-containers/caas-assisted-installer/config/service_vars.sh

/opt/service-containers/caas-assisted-installer/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

# Download RHCOS live CD
if [[ ! -f $OAS_LIVE_CD ]]; then
    echo "Base Live ISO not found. Downloading RHCOS live CD from $BASE_OS_IMAGE"
    curl -L $BASE_OS_IMAGE -o $OAS_LIVE_CD
fi

# Download RHCOS installer
if [[ ! -f $OAS_COREOS_INSTALLER ]]; then
    podman run --privileged -it --rm \
        -v ${OAS_HOSTDIR}:/data \
        -w /data \
        --entrypoint /bin/bash \
        ${COREOS_INSTALLER} \
        -c 'cp /usr/sbin/coreos-installer /data/coreos-installer'
fi

#echo "Starting container ${CONTAINER_NAME}..."
#/usr/bin/podman run --cap-add SYS_ADMIN \
# -d --name "${CONTAINER_NAME}" \
# --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" \
# $CONTAINER_PORTS \
# -v ${EXPORTS_CFG_VOLUME_MOUNT} \
# -v ${NFS_BASE_VOLUME_MOUNT} \
# ${RESOURCE_LIMITS} \
# ${CONTAINER_SOURCE}