#!/bin/bash

set -x

source /opt/caas/nextcloud/config/service_vars.sh

${POD_VOLUME_ROOT}/config/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

# Prepare for persistence
# NOTE: Make sure to delete this directory if persistence is not desired for a new environment!
mkdir -p ${POD_VOLUME_ROOT}/volumes/{db_data,redis_data}
chown -R 33 ${POD_VOLUME_ROOT}/volumes/
chown -R 1001 ${POD_VOLUME_ROOT}/volumes/{db_data,redis_data}
chown -R 33 /mnt/primary/nfs/nextcloud/

rm nohup.out

# Create Pod and deploy containers
echo -e "Deploying Pod...\n"
podman pod create --name "${POD_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" ${CONTAINER_PORTS} ${DB_PORT} ${REDIS_PORT}

sleep 3

# Deploy database
echo -e "Deploying Database...\n"
nohup podman run -dt --pod "${POD_NAME}" ${DB_ENV_DEFS} \
  ${DB_VOLUME_MOUNTS} --name nextcloud-db $DB_CONTAINER_IMAGE

sleep 3

# Deploy Redis
echo -e "Deploying Redis...\n"
nohup podman run -dt --pod "${POD_NAME}" ${REDIS_ENV_DEFS} \
  ${REDIS_VOLUME_MOUNTS} --name nextcloud-redis $REDIS_CONTAINER_IMAGE

sleep 3

# Deploy Nextcloud
echo -e "Deploying Nextcloud...\n"
nohup podman run -dt --pod "${POD_NAME}" ${VOLUME_MOUNTS} ${NEXTCLOUD_ENV_DEFS} \
  --restart always \
  --name nextcloud-srvr $NEXTCLOUD_CONTAINER_IMAGE