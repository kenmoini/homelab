#!/bin/bash

CONTAINER_NAME="dns-core-1"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.9"
CONTAINER_PORT="53"

VOLUME_MOUNT_ONE="/opt/service-containers/${CONTAINER_NAME}/volumes/etc-conf:/etc/go-zones/"
VOLUME_MOUNT_TWO="/opt/service-containers/${CONTAINER_NAME}/volumes/vendor-conf:/opt/app-root/vendor/bind/"

CONTAINER_SOURCE="quay.io/kenmoini/go-zones:file-to-bind"

RESOURCE_LIMITS="-m 1024m"