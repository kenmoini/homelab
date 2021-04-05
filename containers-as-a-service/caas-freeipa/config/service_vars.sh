#!/bin/bash

CONTAINER_NAME="caas-freeipa"
CONTAINER_HOSTNAME="idm.kemo.labs"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.13"

CONTAINER_PORTS="-p 53:53/udp -p 53:53 -p 80:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 -p 88:88/udp -p 464:464/udp -p 123:123/udp"

IPA_DATA_VOLUME_MOUNT="/opt/service-containers/${CONTAINER_NAME}/volumes/ipa-data:/data:Z"

CONTAINER_SOURCE="freeipa-server"

RESOURCE_LIMITS="-m 1024m"