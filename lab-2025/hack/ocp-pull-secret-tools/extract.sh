#!/bin/bash

# Check to see if a pull secret was supplied
if [ -z "${1}" ]; then
  echo "Need a pull secret file as an argument!"
  echo "${0} /path/to/pull-secret.json"
  exit 1
fi

export RH_PULL_SECRET_PATH=${1}

# Check for jq
if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    exit
fi

# Set the Quay.io Authentication Variables
export QUAY_AUTH=$(jq -rMc '.auths["quay.io"].auth' $RH_PULL_SECRET_PATH | base64 -d)
export QUAY_USERNAME=$(echo $QUAY_AUTH | cut -d: -f1)
export QUAY_PASSWORD=$(echo $QUAY_AUTH | cut -d: -f2)

# Create the Quay Authenication JSON Blob
cat > harbor-quay-cred.json <<EOF
{"account_name": "$QUAY_USERNAME", "docker_cli_password": "$QUAY_PASSWORD"}
EOF

# Set the registry.redhat.io Authentication Variables
export REGISTRY_REDHAT_IO_AUTH=$(jq -rMc '.auths["registry.redhat.io"].auth' $RH_PULL_SECRET_PATH | base64 -d)
export REGISTRY_REDHAT_IO_USERNAME=$(echo $REGISTRY_REDHAT_IO_AUTH | cut -d: -f1)
export REGISTRY_REDHAT_IO_PASSWORD=$(echo $REGISTRY_REDHAT_IO_AUTH | cut -d: -f2)

# Create the registry.redhat.io Quay-type Authenication JSON Blob
cat > harbor-registry-redhat-io-cred.json <<EOF
{"account_name": "$REGISTRY_REDHAT_IO_USERNAME", "docker_cli_password": "$REGISTRY_REDHAT_IO_PASSWORD"}
EOF

# Set the registry.connect.redhat.com Authentication Variables
export REGISTRY_CONNECT_REDHAT_COM_AUTH=$(jq -rMc '.auths["registry.connect.redhat.com"].auth' $RH_PULL_SECRET_PATH | base64 -d)
export REGISTRY_CONNECT_REDHAT_COM_USERNAME=$(echo $REGISTRY_CONNECT_REDHAT_COM_AUTH | cut -d: -f1)
export REGISTRY_CONNECT_REDHAT_COM_PASSWORD=$(echo $REGISTRY_CONNECT_REDHAT_COM_AUTH | cut -d: -f2)

# Create the registry.connect.redhat.com Quay-type Authenication JSON Blob
cat > harbor-registry-connect-redhat-com-cred.json <<EOF
{"account_name": "$REGISTRY_CONNECT_REDHAT_COM_USERNAME", "docker_cli_password": "$REGISTRY_CONNECT_REDHAT_COM_PASSWORD"}
EOF

echo "======================================================================================"
echo -e "Extracted quay.io, registry.redhat.io, and registry.connect.redhat.com credentials from pull secret.\n"

echo "======================================================================================"
echo "For Harbor, use the following JSON blobs for the Quay-type credentials:"
echo " - quay.io - harbor-quay-cred.json"
echo " - registry.redhat.io - harbor-registry-redhat-io-cred.json"
echo -e " - registry.connect.redhat.com - harbor-registry-connect-redhat-com-cred.json\n"

echo "======================================================================================"
echo "For JFrog use the following credentials:"
echo " - quay.io"
echo "   Username: $QUAY_USERNAME"
echo -e "   Password: $QUAY_PASSWORD\n"

echo " - registry.redhat.io"
echo "   Username: $REGISTRY_REDHAT_IO_USERNAME"
echo -e "   Password: $REGISTRY_REDHAT_IO_PASSWORD\n"

echo " - registry.connect.redhat.com"
echo "   Username: $REGISTRY_CONNECT_REDHAT_COM_USERNAME"
echo -e "   Password: $REGISTRY_CONNECT_REDHAT_COM_PASSWORD\n"

echo "======================================================================================"
echo -e "Don't forget to add a proxy entry for registry.access.redhat.com - it does not require authentication.\n"
echo "Other common registries to proxy:"
echo " - Docker Hub: docker.io"
echo " - Google Container Registry: gcr.io"
echo " - GitHub Container Registry: ghcr.io"
echo " - Kubernetes Container Registry: registry.k8s.io"

