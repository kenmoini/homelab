#!/bin/bash

set -x

source /opt/service-containers/ingress/scripts/service_vars.sh

${POD_VOLUME_ROOT}/scripts/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

rm nohup.out

## Check for seeded certificate
if [[ ! -f ${POD_VOLUME_ROOT}/certs/default.pem ]]; then
  sh ${POD_VOLUME_ROOT}/seed-cert.sh
fi

# Create Pod and deploy containers
echo -e "Deploying Pod...\n"
podman pod create --name "${POD_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" ${CONTAINER_PORTS}

sleep 3

# Deploy Nginx
echo -e "Deploying Nginx...\n"
nohup podman run -dt --pod "${POD_NAME}" ${NGINX_VOLUME_MOUNTS} -e "NGINX_PORT=8080" --name "${POD_NAME}-nginx" $NGINX_CONTAINER_IMAGE

sleep 3

# Deploy HAProxy
echo -e "Deploying HAProxy...\n"
nohup podman run -dt --sysctl net.ipv4.ip_unprivileged_port_start=0 --pod "${POD_NAME}" ${HAPROXY_VOLUME_MOUNTS} --name "${POD_NAME}-haproxy" $HAPROXY_CONTAINER_IMAGE