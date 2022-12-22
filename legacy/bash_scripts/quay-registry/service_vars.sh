#!/bin/bash

POD_NAME="caas-quay-registry"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.69"
SERVICE_NAME="quay.kemo.labs"

#CONTAINER_PORTS="-p 80/tcp -p 443/tcp" # Prod ports
CONTAINER_PORTS="-p 80/tcp -p 443/tcp -p 8080/tcp -p 8443/tcp -p 9000/tcp -p 9001/tcp -p 8180/tcp -p 8190/tcp"

RESOURCE_LIMITS="-m 8192m"

########################################################################

QUAY_VERSION="3.5.5"
QUAY_PERFORM_CONFIGURATION="false"
QUAY_ROOT_PATH="/mnt/nvme_7TB/quay"
QUAY_CONFIGURATION_PATH="${QUAY_ROOT_PATH}/quay-config.tar.gz"
QUAY_ENABLE_MIRRORING_WORKER="true"
QUAY_IMAGE="registry.redhat.io/quay/quay-rhel8:v${QUAY_VERSION}"

######## PostgreSQL Configuration
POSTGRESQL_USER=quaypgu
POSTGRESQL_PASSWORD=somethingS3cr3t
POSTGRESQL_DATABASE=quay
POSTGRESQL_ADMIN_PASSWORD=ultr4s3cur3
POSTGRESQL_IMAGE="registry.redhat.io/rhel8/postgresql-10:1"

######## Redis Configuration
REDIS_PASSWORD=s0m3Str0ngP455w0rd
REDIS_IMAGE="registry.redhat.io/rhel8/redis-5:1"

######## Quay Configuration
QUAY_CONFIGURATION_IMAGE="registry.redhat.io/quay/quay-rhel8:v${QUAY_VERSION}"

######## Minio Configuration
MINIO_ROOT_USER="AKIAIOSFODNN71337HAX"
MINIO_ROOT_PASSWORD="wJalrXUtnFEMI/K7MDENG/bPxRfiCY1337HAXKEY"
MINIO_REGION_NAME="moon-base-1"
MINIO_POSTGRESQL_DATABASE_NAME="minio"
MINIO_IMAGE="minio/minio"

######## Clair Configuration
CLAIR_POSTGRESQL_DATABASE_NAME="clair"
CLAIR_HTTP_PORT="8180"
CLAIR_INTROSPECTION_PORT="8190"
CLAIR_PSK="MzZmOGM4YWpjYWlhOQ=="
CLAIR_IMAGE="registry.redhat.io/quay/clair-rhel8:v${QUAY_VERSION}"

######## Quay Mirroring Worker Configuration
MIRRORING_WORKER_IMAGE="registry.redhat.io/quay/quay-rhel8:v${QUAY_VERSION}"