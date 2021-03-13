#!/bin/bash

CONTAINER_NAME="dns-pihole-1"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.11"

CONTAINER_PORTS="-p 53/tcp -p 53/udp -p 67/udp -p 80/tcp -p 443/tcp"

VOLUME_MOUNT_ONE="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-pihole:/etc/pihole/"
VOLUME_MOUNT_TWO="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-dnsmasq.d:/etc/dnsmasq.d/"

CONTAINER_SOURCE="pihole/pihole:latest"

RESOURCE_LIMITS="-m 1g"

CEV1="WEBPASSWORD=somePassword"
CEV2="TZ=America/New_York"
CEV3="ADMIN_EMAIL=ken@kenmoini.com"
CEV4="VIRTUAL_HOST=dns-pihole-1"
CEV5="ServerIP=192.168.42.11"
CEV6="ServerIPv6=fdf4:e2e0:df12:a100::11"
CEV7="PIHOLE_DNS_=1.1.1.1;1.0.0.1"
CEV8="TEMPERATUREUNIT=f"

CONTAINER_ENVS="-e ${CEV1} -e ${CEV2} -e ${CEV3} -e ${CEV4} -e ${CEV5} -e ${CEV6} -e ${CEV7} -e ${CEV8}"