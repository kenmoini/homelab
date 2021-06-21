#!/bin/bash

set -x
set -e

source ./cluster-vars.sh

echo -e "Copying OpenShift Assisted Installer ISO to target Libvirt system..."
scp ai-liveiso-$CLUSTER_ID.iso ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT}:${LIBVIRT_REMOTE_ISO_PATH}

if [[ $CLUSTER_TYPE = "Standard" ]]; then
  echo -e "Creating Control Plane Infrastructure...\n"
  for ((n=1;n<=${CLUSTER_CONTROL_PLANE_COUNT};n++))
  do
    echo "Creating Control Plane Node #$n"
    nohup virt-install --connect=${LIBVIRT_URI} -v --mac="${LIBVIRT_MAC_PREFIX}${n}0" ${LIBVIRT_LIKE_OPTIONS} --name=${CLUSTER_NAME}-ocp-cp-${n} --vcpus "sockets=${CLUSTER_CONTROL_PLANE_CPU_SOCKETS},cores=${CLUSTER_CONTROL_PLANE_CPU_CORES},threads=1" --memory="$(expr ${CLUSTER_CONTROL_PLANE_RAM_GB} \* 1024)" --cdrom=${LIBVIRT_REMOTE_ISO_PATH}/ai-liveiso-$CLUSTER_ID.iso --disk "size=${CLUSTER_CONTROL_PLANE_DISK_GB},path=${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-cp-${n}.qcow2,cache=none" --os-variant=rhel8.3 --events "on_reboot=restart" --graphics vnc,listen=${LIBVIRT_ENDPOINT},tlsport=,defaultMode='insecure' --network ${LIBVIRT_NETWORK} &
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