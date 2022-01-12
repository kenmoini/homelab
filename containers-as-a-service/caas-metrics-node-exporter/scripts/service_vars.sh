#!/bin/bash

CONTAINER_NAME="metrics-node-exporter"
NETWORK_NAME="host"

CONTAINER_PORTS="-p 9100:9100"

CONTAINER_SOURCE="quay.io/prometheus/node-exporter"

RESOURCE_LIMITS="-m 512m"