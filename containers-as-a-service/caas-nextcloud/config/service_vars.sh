#!/bin/bash

NXTCLD_DB_DB="nextcloud"
NXTCLD_DB_USER="nextcloud"
NXTCLD_DB_PASS="my0wnPr3ttyC10ud"

POD_NAME="nextcloud"
NEXTCLOUD_CONTAINER_IMAGE="nextcloud:latest"
NETWORK_NAME="bridge0"
IP_ADDRESS="192.168.42.25"

CONTAINER_PORTS="-p 80/tcp -p 443/tcp -p 8080/tcp"

RESOURCE_LIMITS="-m 1024m"

POD_VOLUME_ROOT="/opt/caas/${POD_NAME}"

VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/nextcloud:/var/www/html -v ${POD_VOLUME_ROOT}/volumes/apps:/var/www/html/custom_apps -v ${POD_VOLUME_ROOT}/volumes/config:/var/www/html/config -v ${POD_VOLUME_ROOT}/volumes/data:/var/www/html/data"

##################### DATABASE THINGS
DB_PORT="-p 5432:5432"
DB_CONTAINER_IMAGE="quay.io/bitnami/postgresql:latest"
DB_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/db_data:/bitnami/postgresql"

##################### REDIS THINGS
REDIS_PORT="-p 6379:6379"
REDIS_CONTAINER_IMAGE="quay.io/bitnami/redis:latest"
REDIS_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/redis_data:/bitnami/redis"
REDIS_PASSWORD="sup3rF45tK3yV4lu3St0r3"

##################### REDEFINITIONS for ENV VARS
## Needed by Nextcloud 
NEXTCLOUD_ENV_DEFS="-e POSTGRES_DB=$NXTCLD_DB_DB -e POSTGRESQL_DB=$NXTCLD_DB_DB -e POSTGRES_PASSWORD=$NXTCLD_DB_PASS -e POSTGRESQL_PASSWORD=$NXTCLD_DB_PASS -e POSTGRES_USER=$NXTCLD_DB_USER -e POSTGRESQL_USER=$NXTCLD_DB_USER -e POSTGRES_HOST=localhost -e POSTGRESQL_HOST=localhost -e REDIS_HOST_PASSWORD=${REDIS_PASSWORD}"

## Needed by PostgreSQL
DB_ENV_DEFS="-e POSTGRESQL_USER=${NXTCLD_DB_USER} -e POSTGRESQL_PASSWORD=${NXTCLD_DB_PASS} -e POSTGRESQL_DATABASE=${NXTCLD_DB_DB}"

## Needed by Redis
REDIS_ENV_DEFS="-e REDIS_PASSWORD=${REDIS_PASSWORD}"