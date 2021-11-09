#!/bin/bash

CONTAINER_NAME="radarr"
NETWORK_NAME="bridge0"
IP_ADDRESS="192.168.42.23"

CONTAINER_PORTS="-p 7878/tcp"

CONTAINER_SOURCE="lscr.io/linuxserver/radarr"

RESOURCE_LIMITS="-m 2g"