#!/bin/bash

CONTAINER_NAME="nfs"
NETWORK_NAME="bridge0"
IP_ADDRESS="192.168.42.31"

CONTAINER_PORTS="-p 2049/tcp -p 111/tcp -p 32765/tcp -p 32767/tcp -p 2049/udp -p 111/udp -p 32765/udp -p 32767/udp"

EXPORTS_CFG_VOLUME_MOUNT="/mnt/fastAndLoose/caas/${CONTAINER_NAME}/volumes/etc-conf/exports:/etc/exports"
NFS_BASE_VOLUME_MOUNT="/mnt/fastAndLoose/nfs:/nfs/fast -v /mnt/primary/nfs:/nfs/primary"

CONTAINER_SOURCE="erichough/nfs-server"

RESOURCE_LIMITS="-m 512m"