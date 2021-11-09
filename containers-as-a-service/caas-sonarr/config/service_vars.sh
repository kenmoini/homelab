#!/bin/bash

CONTAINER_NAME="sonarr"
NETWORK_NAME="bridge0"
IP_ADDRESS="192.168.42.22"

CONTAINER_PORTS="-p 8989/tcp"

CONTAINER_SOURCE="lscr.io/linuxserver/sonarr"

RESOURCE_LIMITS="-m 2g"