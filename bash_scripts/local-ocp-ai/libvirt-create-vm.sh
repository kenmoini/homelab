#!/bin/bash

set -e
set -x

source ./cluster-vars.sh

if [[ $CLUSTER_TYPE = "Standard" ]]; then
  echo -e "Creating Control Plane Infrastructure...\n"
  for ((n=1;n<=${CLUSTER_CONTROL_PLANE_COUNT};n++))
  do
    echo "Creating Control Plane Node #$n"
    sleep 3
  done

  echo -e "Creating Application Node Infrastructure...\n"
  for ((n=1;n<=${CLUSTER_APP_NODE_COUNT};n++))
  do
    echo "Creating Application Plane Node #$n"
    sleep 3
  done
fi

if [[ $CLUSTER_TYPE = "SNO" ]]; then
  echo -e "Creating Single Node Infrastructure...\n"
fi