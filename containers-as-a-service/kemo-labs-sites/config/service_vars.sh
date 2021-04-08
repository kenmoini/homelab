#!/bin/bash

CONTAINER_NAME="kemo-labs-sites"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.29"

CONTAINER_PORTS="-p 80/tcp -p 443/tcp"

CONTAINER_SOURCE="quay.io/kenmoini/kemo.labs"

RESOURCE_LIMITS="-m 512m"