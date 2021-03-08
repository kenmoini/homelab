#!/bin/bash

CONTAINER_NAME="dns-pihole-1"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.11"

CONTAINER_PORTS="-p 53:53/tcp -p 53:53/udp -p 67:67/udp -p 80:80/tcp -p 443:443/tcp"

VOLUME_MOUNT_ONE="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-pihole:/etc/pihole/"
VOLUME_MOUNT_TWO="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-dnsmasq.d:/etc/dnsmasq.d/"

CONTAINER_ENV_FILE="/opt/service-containers/${CONTAINER_NAME}/config/container_vars"

CONTAINER_SOURCE="pihole/pihole:latest"