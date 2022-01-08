#!/bin/bash

POD_NAME="metrics"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.27"
CONTAINER_PORTS="-p 3000/tcp -p 8080/tcp -p 9090/tcp -p 9093/tcp -p 5432/tcp"
#RESOURCE_LIMITS="-m 2048m"

POD_VOLUME_ROOT="/opt/service-containers/${POD_NAME}"

GRAFANA_CONTAINER_NAME="grafana"
GRAFANA_IMAGE="quay.io/bitnami/grafana:latest"
GRAFANA_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/grafana-provisioning:/opt/bitnami/grafana/conf/provisioning -v ${POD_VOLUME_ROOT}/volumes/grafana-config/grafana.ini:/opt/bitnami/grafana/conf/grafana.ini -v ${POD_VOLUME_ROOT}/volumes/grafana-data:/opt/bitnami/grafana/data"
GRAFANA_ENV_VARS="-e GF_SECURITY_ADMIN_USER=kemo -e GF_SECURITY_ADMIN_PASSWORD=$(cat /opt/service-containers/secrets/grafana-admin-password) -e GF_RENDERING_SERVER_URL=http://localhost:8080/render -e GF_RENDERING_CALLBACK_URL=http://localhost:3000/"
GRAFANA_RESOURCE_LIMITS="-m 2048m"

GRAFANA_IMAGE_RENDERER_NAME="grafana-image-renderer"
GRAFANA_IMAGE_RENDERER_IMAGE="quay.io/bitnami/grafana-image-renderer:latest"
GRAFANA_IMAGE_RENDERER_ENV_VARS='-e HTTP_PORT=8080 -e ENABLE_METRICS="true"'
GRAFANA_IMAGE_RENDERER_RESOURCE_LIMITS="-m 512m"

PROMETHEUS_CONTAINER_NAME="prometheus"
PROMETHEUS_IMAGE="quay.io/prometheus/prometheus:latest"
PROMETHEUS_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/prom-config:/etc/prometheus:ro -v ${POD_VOLUME_ROOT}/volumes/prom-data:/prometheus:rw"
PROMETHEUS_RESOURCE_LIMITS="-m 2048m"

ALERT_MANAGER_CONTAINER_NAME="alertmanager"
ALERT_MANAGER_IMAGE="quay.io/prometheus/alertmanager:latest"
ALERT_MANAGER_RESOURCE_LIMITS="-m 512m"
ALERT_MANAGER_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/alertmanager-data:/alertmanager"

GRAFANA_POSTGRESQL_CONTAINER_NAME="grafana-postgresql"
GRAFANA_POSTGRESQL_IMAGE="quay.io/bitnami/postgresql:latest"
GRAFANA_POSTGRESQL_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/grafana-postgresql-data:/bitnami/postgresql"
GRAFANA_POSTGRESQL_RESOURCE_LIMITS="-m 512m"
GRAFANA_POSTGRESQL_ENV_VARS="-e POSTGRESQL_USERNAME=metrics -e POSTGRESQL_PASSWORD=observability -e POSTGRESQL_DATABASE=grafana"