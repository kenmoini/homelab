#!/bin/bash

################################################################################
## Ansible Automation Platform 2 Setup Script
##
## This script will configure an AAP2 Controller/Tower instance running in
## OpenShift to be ready for use in a ZTP workflow with vSphere.
################################################################################

## AAP2 DEPLOYMENT VARIABLES
AAP2_NAMESPACE="ansible-automation-platform"
AAP2_CONTROLLER_NAME="ac-tower"
AAP2_ADMIN_SECRET_NAME="${AAP2_CONTROLLER_NAME}-admin-password"
AAP2_CONTROLLER_ROUTE_NAME="${AAP2_CONTROLLER_NAME}"

## AAP2 DEPLOYMENT OBJECTS
AAP2_CONTROLLER_ROUTE=$(oc get route ${AAP2_CONTROLLER_ROUTE_NAME} -n ${AAP2_NAMESPACE} -o jsonpath='{.spec.host}')
AAP2_ADMIN_PASSWORD=$(oc get secret ${AAP2_ADMIN_SECRET_NAME} -n ${AAP2_NAMESPACE} -o jsonpath='{.data.password}' | base64 -d)

## AAP2 DEPLOYMENT CONFIGURATION
ORGANIZATION="Default"
INVENTORY_NAME="localhost-ee"

SCM_CREDENTIAL_AUTH_TYPE="ssh" # ssh or basic
SCM_CREDENTIAL_PRIVATE_KEY="$(sed -z 's|\n|\\n|g' ~/.ssh/id_rsa)"
SCM_CREDENTIAL_USERNAME="your-username"
SCM_CREDENTIAL_PASSWORD="your-password"
SCM_CREDENTIAL_NAME="SCM Credentials"

PROJECT_NAME="ztp"
PROJECT_SOURCE="git@github.com:kenmoini/wg-serto-ztp.git"

################################################################################
## PREFLIGHT
echo "ADMIN PASSWORD: ${AAP2_ADMIN_PASSWORD}"

## Get OAuth2 token
AAP2_OAUTH_TOKEN=$(curl -sSk -u admin:${AAP2_ADMIN_PASSWORD} -H 'Content-Type: application/json' -X POST https://${AAP2_CONTROLLER_ROUTE}/api/v2/tokens/ | jq -r .token)
echo "OAUTH2 TOKEN: ${AAP2_OAUTH_TOKEN}"

## Get Organization ID
AAP2_ORGANIZATION_ID=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -H 'Content-Type: application/json' -X GET https://${AAP2_CONTROLLER_ROUTE}/api/v2/organizations/${ORGANIZATION}/ | jq -r .id)
echo "${ORGANIZATION} ORG ID: ${AAP2_ORGANIZATION_ID}"

################################################################################
## Check for Inventory
INVENTORY_CHECK=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" https://${AAP2_CONTROLLER_ROUTE}/api/v2/inventories/?name=${INVENTORY_NAME})

## If not found, create it
if [ "$(echo ${INVENTORY_CHECK} | jq -r .count)" -eq "0" ]; then
  echo "Inventory does not exist, creating..."
  curl -sSkL -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -H 'Content-Type: application/json' -X POST -d '{"name": "'${INVENTORY_NAME}'", "description": "", "organization": '${AAP2_ORGANIZATION_ID}', "kind": "", "variables": {}, "host_filter": "", "host_vars": {}, "group_vars": {}, "groups": [], "hosts": []}' https://${AAP2_CONTROLLER_ROUTE}/api/v2/inventories/ > /dev/null 2>&1
else
  echo "Inventory exists, skipping..."
fi

## Pull the Inventory ID we just created
INVENTORY_ID_PULL=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" https://${AAP2_CONTROLLER_ROUTE}/api/v2/inventories/?name=${INVENTORY_NAME} | jq -r .results[0].id)
echo "INVENTORY_ID: ${INVENTORY_ID_PULL}"

################################################################################
## Check for Host in Inventory
HOST_CHECK=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" https://${AAP2_CONTROLLER_ROUTE}/api/v2/inventories/${INVENTORY_ID_PULL}/hosts/?name=localhost | jq -r .count)
## Add host if it does not exist
if [ "$HOST_CHECK" -eq "0" ]; then
  echo "Host does not exist, creating..."
  curl -sSkL -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -H 'Content-Type: application/json' -X POST -d '{"name": "localhost", "description": "", "organization": '${AAP2_ORGANIZATION_ID}', "variables": "---\nansible_connection: local\nansible_python_interpreter: \"{{ ansible_playbook_python }}\"", "host_filter": "", "kind": ""}' https://${AAP2_CONTROLLER_ROUTE}/api/v2/inventories/${INVENTORY_ID_PULL}/hosts/ > /dev/null 2>&1
else
  echo "Host exists, skipping..."
fi

################################################################################
## Get Credential Type ID
SCM_CREDENTIAL_TYPE_ID=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -G -H 'Content-Type: application/json' --data-urlencode "name=Source Control" https://${AAP2_CONTROLLER_ROUTE}/api/v2/credential_types/ | jq -r .results[0].id)

################################################################################
## Check for Credential
CREDENTIAL_CHECK=$(curl -sSk -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -G -H 'Content-Type: application/json' --data-urlencode "name=${SCM_CREDENTIAL_NAME}" https://${AAP2_CONTROLLER_ROUTE}/api/v2/credentials/ | jq -r .count)
## If not found, create it
if [ "$CREDENTIAL_CHECK" -eq "0" ]; then
  echo "Credential does not exist, creating..."
  set -x
  if [ "${SCM_CREDENTIAL_AUTH_TYPE}" == "ssh" ]; then
    curl -sSkL -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -H 'Content-Type: application/json' -X POST -d '{"name": "'"${SCM_CREDENTIAL_NAME}"'", "description": "", "organization": '${AAP2_ORGANIZATION_ID}', "kind": "", "inputs": {"ssh_key_data": "'"$SCM_CREDENTIAL_PRIVATE_KEY"'"}, "credential_type": '${SCM_CREDENTIAL_TYPE_ID}'}' https://${AAP2_CONTROLLER_ROUTE}/api/v2/credentials/ > /dev/null 2>&1
  fi
  if [ "${SCM_CREDENTIAL_AUTH_TYPE}" == "basic" ]; then
    curl -sSkL -H "Authorization: Bearer ${AAP2_OAUTH_TOKEN}" -H 'Content-Type: application/json' -X POST -d '{"name": "'"${SCM_CREDENTIAL_NAME}"'", "description": "", "organization": '${AAP2_ORGANIZATION_ID}', "kind": "", "inputs": {"username": "'${SCM_CREDENTIAL_USERNAME}'", "password": "'${SCM_CREDENTIAL_PASSWORD}'"}, "credential_type": '${SCM_CREDENTIAL_TYPE_ID}'}' https://${AAP2_CONTROLLER_ROUTE}/api/v2/credentials/ > /dev/null 2>&1
  fi
else
  echo "Credential exists, skipping..."
fi

## Check for Project
## If not found, create it

## Check for Job Template
## If not found, create it

## Check for Application
## If not found, create it

## Check for Application User Token
## If not found, create it