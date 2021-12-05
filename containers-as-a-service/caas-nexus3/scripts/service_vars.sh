#!/bin/bash

CONTAINER_NAME="nexus3"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.22"
CONTAINER_PORTS="-p 8081/tcp -p 5000/tcp"
RESOURCE_LIMITS="-m 4096m"

POD_VOLUME_ROOT="/opt/service-containers/${CONTAINER_NAME}"

CONTAINER_IMAGE="registry.connect.redhat.com/sonatype/nexus-repository-manager:latest"
VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/nexus-data:/nexus-data"