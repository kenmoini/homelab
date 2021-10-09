#!/bin/bash

POD_NAME="ingress"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.28"
CONTAINER_PORTS="-p 80/tcp -p 443/tcp -p 8080/tcp"
RESOURCE_LIMITS="-m 2048m"

POD_VOLUME_ROOT="/opt/service-containers/${POD_NAME}"

HAPROXY_CONTAINER_IMAGE="haproxy:latest"
NGINX_CONTAINER_IMAGE="nginx:latest"

HAPROXY_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/haproxy:/usr/local/etc/haproxy:ro -v ${POD_VOLUME_ROOT}/certs:/usr/local/etc/certs:ro"
NGINX_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/webroot:/usr/share/nginx/html -v ${POD_VOLUME_ROOT}/nginx-templates:/etc/nginx/templates"