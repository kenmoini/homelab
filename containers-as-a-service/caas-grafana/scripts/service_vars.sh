#!/bin/bash

POD_NAME="grafana"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.27"
CONTAINER_PORTS="-p 80/tcp -p 443/tcp"
RESOURCE_LIMITS="-m 2048m"

POD_VOLUME_ROOT="/opt/service-containers/${POD_NAME}"

GRAFANA_CONTAINER_IMAGE="grafana/grafana-oss:latest"
GRAFANA_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/haproxy:/usr/local/etc/haproxy:ro -v ${POD_VOLUME_ROOT}/certs:/usr/local/etc/certs:ro"
