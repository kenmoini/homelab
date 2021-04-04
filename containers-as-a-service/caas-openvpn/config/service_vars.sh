#!/bin/bash

CONTAINER_NAME="caas-openvpn"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.19"

CONTAINER_PORTS="-p 1194/udp"

OVPN_VOLUME_MOUNT="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-conf:/etc/openvpn"

CONTAINER_SOURCE="kylemanna/openvpn"

RESOURCE_LIMITS="-m 512m"