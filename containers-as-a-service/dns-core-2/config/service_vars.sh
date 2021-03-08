#!/bin/bash

CONTAINER_NAME="dns-core-2"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.10"
CONTAINER_PORT="53"

VOLUME_MOUNT_ONE="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-conf:/etc/go-zones/"
CONTAINER_SOURCE="quay.io/kenmoini/go-zones:file-to-bind"