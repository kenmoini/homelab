#!/bin/bash

CONTAINER_NAME="caas-assisted-installer"
NETWORK_NAME="lanBridge"
IP_ADDRESS="192.168.42.70"

CONTAINER_PORTS="-p 8090/tcp -p 8080/tcp -p 8000/tcp -p 5432/tcp -p 8090/udp -p 8080/udp -p 8000/udp -p 5432/udp"

RESOURCE_LIMITS="-m 4096m"

########################################################################
RHCOS_VERSION="latest"

# BASE_OS_IMAGE matches current release, which is 4.7.x
BASE_OS_IMAGE=https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.8/${RHCOS_VERSION}/rhcos-live.x86_64.iso

# Tested with:
OAS_UI_IMAGE=quay.io/ocpmetal/ocp-metal-ui:stable.10.08.2021-09.50
OAS_IMAGE=quay.io/ocpmetal/assisted-service:stable.10.08.2021-09.50
COREOS_INSTALLER=quay.io/coreos/coreos-installer:v0.10.0
OAS_DB_IMAGE=quay.io/ocpmetal/postgresql-12-centos7

OAS_HOSTDIR=/opt/service-containers/caas-assisted-installer
OAS_ENV_FILE=${OAS_HOSTDIR}/volumes/opt/onprem-environment
OAS_UI_CONF=${OAS_HOSTDIR}/volumes/opt/nginx-ui.conf
OAS_LIVE_CD=${OAS_HOSTDIR}/local-store/rhcos-live.x86_64.iso
OAS_COREOS_INSTALLER=${OAS_HOSTDIR}/local-store/coreos-installer

SERVICE_FQDN="assisted-installer.kemo.labs"

########################################################################