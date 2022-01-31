#!/bin/bash

################################################################################ VARIABLES
## POD THINGS
POD_NAME="keycloak"
POD_NETWORK_NAME="lanBridge"
POD_IP_ADDRESS="192.168.42.18"
POD_PORTS="-p 8080/tcp"
POD_VOLUME_ROOT="/opt/service-containers/${POD_NAME}"

DB_DB="keycloak"
DB_USER="keycloakdbu"
DB_PASS="$(cat ${POD_VOLUME_ROOT}/secrets/db.pass)"

KEYCLOAK_USER="admin"
KEYCLOAK_PASS="$(cat ${POD_VOLUME_ROOT}/secrets/admin.pass)"

################################################################################
## KEYCLOAK THINGS
KEYCLOAK_CONTAINER_NAME="keycloak-server"
KEYCLOAK_CONTAINER_IMAGE="quay.io/keycloak/keycloak:latest"
KEYCLOAK_RESOURCE_LIMITS="-m 4096m"
## Most of Keycloak's config is in the DB, so unless doing specific modifications to the XML or JBOSS config, no need for a persistent volume
#KEYCLOAK_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/keycloak-data:/opt/jboss"
KEYCLOAK_ENV_VARS="-e DB_VENDOR=POSTGRES -e DB_ADDR=localhost -e DB_USER=${DB_USER} -e DB_PASSWORD=${DB_PASS} -e PROXY_ADDRESS_FORWARDING=true -e KEYCLOAK_USER=${KEYCLOAK_USER} -e KEYCLOAK_PASSWORD=${KEYCLOAK_PASS}"

################################################################################
## DATABASE THINGS
POSTGRES_CONTAINER_NAME="keycloak-db"
POSTGRES_CONTAINER_IMAGE="quay.io/bitnami/postgresql:latest"
POSTGRES_RESOURCE_LIMITS="-m 512m"
POSTGRES_VOLUME_MOUNTS="-v ${POD_VOLUME_ROOT}/volumes/postgresql-data:/bitnami/postgresql"
POSTGRES_ENV_VARS="-e POSTGRESQL_USERNAME=${DB_USER} -e POSTGRESQL_PASSWORD=${DB_PASS} -e POSTGRESQL_DATABASE=${DB_DB}"


################################################################################### EXECUTION PREFLIGHT
## Ensure there is an action arguement
if [ -z "$1" ]; then
  echo "Need action arguement of 'start', 'restart', or 'stop'!"
  echo "${0} start|stop|restart"
  exit 1
fi

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${POD_NETWORK_NAME}/${POD_IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi


################################################################################### SERVICE ACTION SWITCH
case $1 in

  ################################################################################# RESTART/STOP SERVICE
  "restart" | "stop" | "start")
    echo "Stopping container services if running..."

    echo "Killing Keycloak containers and pod..."
    /usr/bin/podman kill ${KEYCLOAK_CONTAINER_NAME}
    /usr/bin/podman kill ${POSTGRES_CONTAINER_NAME}
    /usr/bin/podman pod kill ${POD_NAME}

    echo "Removing Keycloak containers and pod..."
    /usr/bin/podman rm -f -i ${KEYCLOAK_CONTAINER_NAME}
    /usr/bin/podman rm -f -i ${POSTGRES_CONTAINER_NAME}
    /usr/bin/podman pod rm -f -i ${POD_NAME}
    ;;

esac

case $1 in

  ################################################################################# RESTART/START SERVICE
  "restart" | "start")
    echo -e "Deploying Pod...\n"
    podman pod create --name "${POD_NAME}" --network "${POD_NETWORK_NAME}" --ip "${POD_IP_ADDRESS}" ${POD_PORTS}

    sleep 3

    chown -R 1001:1001 ${POD_VOLUME_ROOT}/volumes/postgresql-data

    echo "Starting container services..."

    # Deploy PostgreSQL
    echo -e "Deploying PostgreSQL...\n"
    podman run -dt --name ${POSTGRES_CONTAINER_NAME} \
    --pod ${POD_NAME} \
    ${POSTGRES_VOLUME_MOUNTS} \
    ${POSTGRES_ENV_VARS} \
    ${POSTGRES_RESOURCE_LIMITS} \
    ${POSTGRES_CONTAINER_IMAGE}

    sleep 5

    # Deploy Keycloak
    echo -e "Deploying Keycloak...\n"
    podman run -dt --name ${KEYCLOAK_CONTAINER_NAME} \
    --pod ${POD_NAME} \
    ${KEYCLOAK_ENV_VARS} \
    ${KEYCLOAK_RESOURCE_LIMITS} \
    ${KEYCLOAK_CONTAINER_IMAGE}

    ;;

esac