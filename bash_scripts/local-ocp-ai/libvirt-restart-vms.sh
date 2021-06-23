#!/bin/bash

#set -x
#set -e

source ./cluster-vars.sh

# Make an array
VM_ARR=()

# Loop...
for ((n=1;n<=${CLUSTER_CONTROL_PLANE_COUNT};n++))
do
  VM_ARR+=("${CLUSTER_NAME}-ocp-cp-${n}")
done

# ...de loop
for ((n=1;n<=${CLUSTER_APP_NODE_COUNT};n++))
do
  VM_ARR+=("${CLUSTER_NAME}-ocp-app-${n}")
done

LOOP_ON="true"
intV="0"
VIRSH_WATCH_CMD="virsh list --state-shutoff --name"

while [ $LOOP_ON = "true" ]; do
  currentPoweredOffVMs=$($VIRSH_WATCH_CMD)
  while IFS="" read -r p || [ -n "$p" ]
  do
    printf '%s and\n' "$p"
  done <<<$currentPoweredOffVMs

  echo $intV
  intV=$[$intV+1]
  if [ $intV = "3" ]; then
    LOOP_ON="false"
  fi
  sleep 10
done