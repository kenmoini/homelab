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
#if [[ ! -f $OAS_LIVE_CD ]]; then
#    echo "Base Live ISO not found. Downloading RHCOS live CD from $BASE_OS_IMAGE"
#    curl -L $BASE_OS_IMAGE -o $OAS_LIVE_CD
#fi

# Download RHCOS installer
#if [[ ! -f $OAS_COREOS_INSTALLER ]]; then
#  podman run --privileged -it --rm \
#    -v ${OAS_HOSTDIR}/local-store:/data \
#    -w /data \
#    --entrypoint /bin/bash \
#    ${COREOS_INSTALLER} \
#    -c 'cp /usr/sbin/coreos-installer /data/coreos-installer'
#fi

# Prepare for persistence
# NOTE: Make sure to delete this directory if persistence is not desired for a new environment!
#mkdir -p ${OAS_HOSTDIR}/data/postgresql
#chown -R 26 ${OAS_HOSTDIR}/data/postgresql/

# Create Pod and deploy containers
echo -e "Deploying Pod...\n"
podman play kube \
 --configmap /opt/service-containers/caas-assisted-installer/config/configmap.yaml \
 --configmap /opt/service-containers/caas-assisted-installer/config/configmap-certs.yaml \
 --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" \
 /opt/service-containers/caas-assisted-installer/config/pod.yaml

exit 0

##################################################################################################
## Old manual way
##################################################################################################


#podman pod create --name "${CONTAINER_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" -p 8000:8000 -p 8090:8090 -p 8888:8080

sleep 3

# Deploy database
echo -e "Deploying Database...\n"
nohup podman run -dt --pod "${CONTAINER_NAME}" --env-file $OAS_ENV_FILE \
  --volume ${OAS_HOSTDIR}/data/postgresql:/var/lib/pgsql:z \
  --name db $OAS_DB_IMAGE

sleep 3

# Deploy Assisted Service
echo -e "Deploying Assisted Service...\n"
nohup podman run -dt --pod "${CONTAINER_NAME}" \
  -v ${OAS_LIVE_CD}:/data/livecd.iso:z \
  -v ${OAS_COREOS_INSTALLER}:/data/coreos-installer:z \
  --env-file $OAS_ENV_FILE \
  --env DUMMY_IGNITION=False \
  --restart always \
  --name installer $OAS_IMAGE

sleep 45

# Deploy UI
echo -e "Deploying UI...\n"
nohup podman run -dt --pod "${CONTAINER_NAME}" --env-file $OAS_ENV_FILE \
  -v ${OAS_UI_CONF}:/opt/bitnami/nginx/conf/server_blocks/nginx.conf:z \
  --name ui $OAS_UI_IMAGE

#echo "Starting container ${CONTAINER_NAME}..."
#/usr/bin/podman run --cap-add SYS_ADMIN \
# -d --name "${CONTAINER_NAME}" \
# --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" \
# $CONTAINER_PORTS \
# -v ${EXPORTS_CFG_VOLUME_MOUNT} \
# -v ${NFS_BASE_VOLUME_MOUNT} \
# ${RESOURCE_LIMITS} \
# ${CONTAINER_SOURCE}