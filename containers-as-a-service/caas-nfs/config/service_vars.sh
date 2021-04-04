#!/bin/bash

CONTAINER_NAME="caas-nfs"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.31"

CONTAINER_PORTS="-p 2049/tcp -p 111/tcp -p 32765/tcp -p 32767/tcp -p 2049/udp -p 111/udp -p 32765/udp -p 32767/udp"

EXPORTS_CFG_VOLUME_MOUNT="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-conf/exports:/etc/exports"
NFS_BASE_VOLUME_MOUNT="/mnt/nvme_7TB/nfs:/nfs"

CONTAINER_SOURCE="quay.io/kenmoini/nfs-ubi:latest"

RESOURCE_LIMITS="-m 512m"