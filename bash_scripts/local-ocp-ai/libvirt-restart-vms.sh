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
VIRSH_WATCH_CMD="sudo virsh list --state-shutoff --name"

echo "========= Cluster VMs: ${VM_ARR[@]}"

while [ $LOOP_ON = "true" ]; do
  currentPoweredOffVMs=$($VIRSH_WATCH_CMD)

  # loop through VMs that are powered off
  while IFS="" read -r p || [ -n "$p" ]
  do
    if [[ " ${VM_ARR[@]} " =~ " ${p} " ]]; then
      # Powered off VM matches the original list of VMs, turn it on and remove from array
      echo "========= Starting VM: ${p} ..."
      sudo virsh start $p
      # Remove from original array
      TMP_ARR=()
      for val in "${VM_ARR[@]}"; do
        [[ $val != $p ]] && TMP_ARR+=($val)
      done
      VM_ARR=("${TMP_ARR[@]}")
      unset TMP_ARR
    fi
  done < <(printf '%s' "${currentPoweredOffVMs}")

  echo "${#VM_ARR[@]}"
  if [ '0' -eq "${#VM_ARR[@]}" ]; then
    LOOP_ON="false"
    echo "========= All Cluster VMs have been restarted!"
    exit
  fi
  echo "========= Still waiting on: ${VM_ARR[@]}"
  sleep 10
done
