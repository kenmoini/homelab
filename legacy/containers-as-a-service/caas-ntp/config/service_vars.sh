#!/bin/bash

CONTAINER_NAME="caas-ntp"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.14"

CONTAINER_PORTS="-p 123/udp -p 321/udp"

CONTAINER_ENV_VARS='-e NTP_SERVERS="time.apple.com"'

#CONTAINER_SOURCE="quay.io/kenmoini/ubi8-ntp-server:latest"
CONTAINER_SOURCE="cturra/ntp:latest"

RESOURCE_LIMITS="-m 256m"