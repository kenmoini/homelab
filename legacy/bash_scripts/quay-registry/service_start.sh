#!/bin/bash

set -x

SOURCE_ROOT=/home/kemo/homelab/containers-as-a-service/quay-registry

source ${SOURCE_ROOT}/config/service_vars.sh
${SOURCE_ROOT}/config/service_stop.sh

function promptToContinueAfterConfiguration {
    echo -e "\n================================================================================"
    read -p "Have you completed the Configuration and moved the package to ${QUAY_CONFIGURATION_PATH}? [N/y] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [[ -f $QUAY_CONFIGURATION_PATH ]]; then
          echo "Package found!"
        else
          promptToContinueAfterConfiguration
        fi
    else
        promptToContinueAfterConfiguration
    fi
}

sleep 3

echo "Checking for stale network lock file..."
FILE_CHECK="/var/lib/cni/networks/${NETWORK_NAME}/${IP_ADDRESS}"
if [[ -f "$FILE_CHECK" ]]; then
    rm $FILE_CHECK
fi

# Create Pod and deploy containers
echo -e "Deploying Pod...\n"
podman pod create --name "${POD_NAME}" --network "${NETWORK_NAME}" --ip "${IP_ADDRESS}" ${CONTAINER_PORTS}

# Setup PostgreSQL
if [[ ! -d $QUAY_ROOT_PATH/postgres-quay ]]; then
  echo -e "Creating PostgreSQL data directory (${QUAY_ROOT_PATH}/postgres-quay)..."
  mkdir -p $QUAY_ROOT_PATH/postgres-quay
  chown -R 26 $QUAY_ROOT_PATH/postgres-quay
  setfacl -m u:26:-wx $QUAY_ROOT_PATH/postgres-quay
fi

# Deploy PostgreSQL database
echo -e "Deploying PostgreSQL Database...\n"
podman run -dt --rm --pod "${POD_NAME}" \
  -e POSTGRESQL_USER=${POSTGRESQL_USER} \
  -e POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD} \
  -e POSTGRESQL_DATABASE=${POSTGRESQL_DATABASE} \
  -e POSTGRESQL_ADMIN_PASSWORD=${POSTGRESQL_ADMIN_PASSWORD} \
  -v $QUAY_ROOT_PATH/postgres-quay:/var/lib/pgsql:Z \
  --name postgresql-quay $POSTGRESQL_IMAGE

sleep 3

podman exec -it postgresql-quay /bin/bash -c "psql -U postgres -d ${POSTGRESQL_DATABASE} -tc 'CREATE EXTENSION IF NOT EXISTS \"pg_trgm\";'"
podman exec -it postgresql-quay /bin/bash -c 'psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '\'${MINIO_POSTGRESQL_DATABASE_NAME}\''" | grep -q 1 || psql -U postgres -c "CREATE DATABASE '${MINIO_POSTGRESQL_DATABASE_NAME}'"'
podman exec -it postgresql-quay /bin/bash -c 'psql -U postgres -tc "GRANT ALL PRIVILEGES ON DATABASE '${MINIO_POSTGRESQL_DATABASE_NAME}' TO '${POSTGRESQL_USER}'"'
podman exec -it postgresql-quay /bin/bash -c "psql -U postgres -d ${MINIO_POSTGRESQL_DATABASE_NAME} -tc 'CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";'"
podman exec -it postgresql-quay /bin/bash -c 'psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '\'${CLAIR_POSTGRESQL_DATABASE_NAME}\''" | grep -q 1 || psql -U postgres -c "CREATE DATABASE '${CLAIR_POSTGRESQL_DATABASE_NAME}'"'
podman exec -it postgresql-quay /bin/bash -c 'psql -U postgres -tc "GRANT ALL PRIVILEGES ON DATABASE '${CLAIR_POSTGRESQL_DATABASE_NAME}' TO '${POSTGRESQL_USER}'"'
podman exec -it postgresql-quay /bin/bash -c "psql -U postgres -d ${CLAIR_POSTGRESQL_DATABASE_NAME} -tc 'CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";'"

sleep 3

# Deploy Redis
echo -e "Deploying Redis...\n"
podman run -dt --rm --pod "${POD_NAME}" \
  -e REDIS_PASSWORD=${REDIS_PASSWORD} \
  --name redis-quay $REDIS_IMAGE

# Setup Minio
if [[ ! -d $QUAY_ROOT_PATH/minio-quay ]]; then
  echo -e "Creating Minio data directory (${QUAY_ROOT_PATH}/minio-quay)..."
  mkdir -p $QUAY_ROOT_PATH/minio-quay
fi

# Deploy Minio
echo -e "Deploying Minio...\n"
podman run -dt --rm --pod "${POD_NAME}" \
  -v $QUAY_ROOT_PATH/minio-quay:/data \
  -e "MINIO_ROOT_USER=${MINIO_ROOT_USER}" \
  -e "MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}" \
  -e "MINIO_DOMAIN=${SERVICE_NAME}" \
  -e "MINIO_REGION_NAME=${MINIO_REGION_NAME}" \
  --name minio-quay $MINIO_IMAGE server /data --console-address ":9001"


# Setup Clair
if [[ ! -d $QUAY_ROOT_PATH/clair-quay ]]; then
  echo -e "Creating Clair data directory (${QUAY_ROOT_PATH}/clair-quay)..."
  mkdir -p $QUAY_ROOT_PATH/clair-quay
fi
# Create Clair configuration
cat << EOF > ${QUAY_ROOT_PATH}/clair-quay/config.yaml
introspection_addr: :${CLAIR_INTROSPECTION_PORT}
http_listen_addr: :${CLAIR_HTTP_PORT}
log_level: debug
indexer:
  connstring: host=postgresql-quay port=5432 dbname=${CLAIR_POSTGRESQL_DATABASE_NAME} user=${POSTGRESQL_USER} password=${POSTGRESQL_PASSWORD} sslmode=disable
  scanlock_retry: 10
  layer_scan_concurrency: 5
  migrations: true
matcher:
  connstring: host=postgresql-quay port=5432 dbname=${CLAIR_POSTGRESQL_DATABASE_NAME} user=${POSTGRESQL_USER} password=${POSTGRESQL_PASSWORD} sslmode=disable
  max_conn_pool: 100
  run: ""
  migrations: true
  indexer_addr: clair-indexer
notifier:
  connstring: host=postgresql-quay port=5432 dbname=${CLAIR_POSTGRESQL_DATABASE_NAME} user=${POSTGRESQL_USER} password=${POSTGRESQL_PASSWORD} sslmode=disable
  delivery_interval: 1m
  poll_interval: 5m
  migrations: true
auth:
  psk:
    key: ${CLAIR_PSK}
    iss: ["quay"]
EOF

# Deploy Clair
echo -e "Deploying Clair...\n"
podman run -dt --pod "${POD_NAME}" \
  -v $QUAY_ROOT_PATH/clair-quay:/clair \
  -e CLAIR_CONF=/clair/config.yaml \
  -e CLAIR_MODE=combo \
  --name clair-quay $CLAIR_IMAGE

# Deploy Configuration Wizard for Quay
if [[ $QUAY_PERFORM_CONFIGURATION = "true" ]]; then
  podman run --rm -it --pod "${POD_NAME}" --name quay_config registry.redhat.io/quay/quay-rhel8:v3.5.5 config secret
  promptToContinueAfterConfiguration
fi

# Deploy Quay
if [[ ! -d $QUAY_ROOT_PATH/quay-config ]]; then
  echo -e "Creating Quay data directory (${QUAY_ROOT_PATH}/quay-config)..."
  mkdir -p $QUAY_ROOT_PATH/quay-config
fi

if [[ ! -f $QUAY_ROOT_PATH/quay-config/config.yaml ]]; then
  if [[ ! -f $QUAY_CONFIGURATION_PATH ]]; then
    echo -e "No config file found! Looking for package at ${QUAY_CONFIGURATION_PATH}"
    promptToContinueAfterConfiguration
  fi
fi

cp $QUAY_CONFIGURATION_PATH ${QUAY_ROOT_PATH}/quay-config/quay-config.tar.gz
cd ${QUAY_ROOT_PATH}/quay-config/
tar zxf quay-config.tar.gz

# Deploy Quay Mirroring Worker
if [[ $QUAY_ENABLE_MIRRORING_WORKER = "true" ]]; then
  echo "Deploying Quay Mirroring Worker..."

  podman run -dt --pod "${POD_NAME}" \
    -v $QUAY_ROOT_PATH/quay-config:/conf/stack:Z \
    --name mirroring-worker-quay $MIRRORING_WORKER_IMAGE repomirror
fi

podman run -dt --pod "${POD_NAME}" \
   -v $QUAY_ROOT_PATH/quay-config:/conf/stack:Z \
   --name quay-quay $QUAY_IMAGE