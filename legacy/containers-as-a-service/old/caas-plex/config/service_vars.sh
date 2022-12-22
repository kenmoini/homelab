#!/bin/bash

CONTAINER_NAME="plex"
NETWORK_NAME="bridge0"
IP_ADDRESS="192.168.42.20"

CONTAINER_PORTS="-p 32400/tcp -p 3005/tcp -p 8324/tcp -p 32469/tcp -p 1900/udp -p 32410/udp -p 32412/udp -p 32413/udp -p 32414/udp"

CONTAINER_SOURCE="plexinc/pms-docker:latest"

RESOURCE_LIMITS="-m 8g"

VOLUME_MOUNTS="-v /mnt/primary/nfs/plex/config:/config -v /mnt/primary/nfs/plex/transcode:/transcode -v /mnt/primary/nfs/media:/data"