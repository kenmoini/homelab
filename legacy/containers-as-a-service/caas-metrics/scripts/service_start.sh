#!/bin/bash

set -x

source /opt/service-containers/metrics/scripts/service_vars.sh

${POD_VOLUME_ROOT}/scripts/service_stop.sh

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

rm nohup.out

# Create Pod and deploy containers
echo -e "Deploying Pod...\n"
podman pod create --name "${POD_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" ${CONTAINER_PORTS}

sleep 3

# Deploy Grafana Image Renderer
echo -e "Deploying Grafana Image Renderer...\n"
podman run -dt --pod "${POD_NAME}" \
 --name ${GRAFANA_IMAGE_RENDERER_NAME} \
 ${GRAFANA_IMAGE_RENDERER_ENV_VARS} \
 ${GRAFANA_IMAGE_RENDERER_RESOURCE_LIMITS} \
 ${GRAFANA_IMAGE_RENDERER_IMAGE}

sleep 5

# Deploy Grafana PostgreSQL DB
echo -e "Deploying Grafana PostgreSQL DB...\n"
podman run -dt --pod "${POD_NAME}" \
 --name ${GRAFANA_POSTGRESQL_CONTAINER_NAME} \
 ${GRAFANA_POSTGRESQL_ENV_VARS} \
 ${GRAFANA_POSTGRESQL_RESOURCE_LIMITS} \
 ${GRAFANA_POSTGRESQL_VOLUME_MOUNTS} \
 ${GRAFANA_POSTGRESQL_IMAGE}

sleep 5

# Deploy Grafana
echo -e "Deploying Grafana...\n"
podman run -dt --pod "${POD_NAME}" \
 --name ${GRAFANA_CONTAINER_NAME} \
 ${GRAFANA_ENV_VARS} \
 ${GRAFANA_RESOURCE_LIMITS} \
 ${GRAFANA_VOLUME_MOUNTS} \
 ${GRAFANA_IMAGE}

sleep 5

# Deploy Alertmanager
echo -e "Deploying Alertmanager...\n"
podman run -dt --pod "${POD_NAME}" \
 --name ${ALERT_MANAGER_CONTAINER_NAME} \
 ${ALERT_MANAGER_RESOURCE_LIMITS} \
 ${ALERT_MANAGER_VOLUME_MOUNTS} \
 ${ALERT_MANAGER_IMAGE}

sleep 5

# Deploy Prometheus
echo -e "Deploying Prometheus...\n"
podman run -dt --pod "${POD_NAME}" \
 --name ${PROMETHEUS_CONTAINER_NAME} \
 ${PROMETHEUS_RESOURCE_LIMITS} \
 ${PROMETHEUS_VOLUME_MOUNTS} \
 ${PROMETHEUS_IMAGE}
