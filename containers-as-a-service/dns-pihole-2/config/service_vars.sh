#!/bin/bash

CONTAINER_NAME="dns-pihole-2"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.12"

CONTAINER_PORTS="-p 53/tcp -p 53/udp -p 67/udp -p 80/tcp -p 443/tcp"

VOLUME_MOUNT_ONE="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-pihole:/etc/pihole/"
VOLUME_MOUNT_TWO="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-dnsmasq.d:/etc/dnsmasq.d/"

CONTAINER_SOURCE="pihole/pihole:latest"

CEV1="WEBPASSWORD=somePassword"
CEV2="TZ=America/New_York"
CEV3="ADMIN_EMAIL=ken@kenmoini.com"
CEV4="VIRTUAL_HOST=dns-pihole-2"
CEV5="ServerIP=192.168.42.12"
CEV6="ServerIPv6=fdf4:e2e0:df12:a100::12"
CEV7="PIHOLE_DNS_=192.168.42.9;192.168.42.10"
CEV8="TEMPERATUREUNIT=f"

CONTAINER_ENVS="-e ${CEV1} -e ${CEV2} -e ${CEV3} -e ${CEV4} -e ${CEV5} -e ${CEV6} -e ${CEV7} -e ${CEV8}"