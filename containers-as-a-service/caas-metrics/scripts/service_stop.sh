#!/bin/bash

set -x

source /opt/service-containers/metrics/scripts/service_vars.sh

echo "Killing containers and pods..."
/usr/bin/podman kill $GRAFANA_CONTAINER_NAME
/usr/bin/podman kill $GRAFANA_IMAGE_RENDERER_NAME
/usr/bin/podman kill $PROMETHEUS_CONTAINER_NAME
/usr/bin/podman kill $ALERT_MANAGER_CONTAINER_NAME
/usr/bin/podman kill $GRAFANA_POSTGRESQL_CONTAINER_NAME
/usr/bin/podman pod kill $POD_NAME

echo "Removing containers and pods..."
/usr/bin/podman rm $GRAFANA_CONTAINER_NAME -f -i
/usr/bin/podman rm $GRAFANA_IMAGE_RENDERER_NAME -f -i
/usr/bin/podman rm $PROMETHEUS_CONTAINER_NAME -f -i
/usr/bin/podman rm $ALERT_MANAGER_CONTAINER_NAME -f -i
/usr/bin/podman rm $GRAFANA_POSTGRESQL_CONTAINER_NAME -f -i
/usr/bin/podman pod rm $POD_NAME -f -i