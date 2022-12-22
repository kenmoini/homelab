#!/bin/bash

set -x
#set -e

source ./cluster-vars.sh

echo -e "Copying OpenShift Assisted Installer ISO to target Libvirt system..."
REMOTE_ISO_EXISTS=$(ssh ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT} ls ${LIBVIRT_REMOTE_ISO_PATH}/ai-liveiso-${CLUSTER_ID}.iso)
if [[ $REMOTE_ISO_EXISTS = "${LIBVIRT_REMOTE_ISO_PATH}/ai-liveiso-${CLUSTER_ID}.iso" ]]; then
  echo -e "ISO already exists on remote host...\n"
else
  scp ai-liveiso-$CLUSTER_ID.iso ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT}:${LIBVIRT_REMOTE_ISO_PATH}
fi

if [[ $CLUSTER_TYPE = "Standard" ]]; then
  echo -e "Creating Control Plane Infrastructure...\n"
  for ((n=1;n<=${CLUSTER_CONTROL_PLANE_COUNT};n++))
  do
    REMOTE_DISK_EXISTS=$(ssh ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT} find ${LIBVIRT_VM_PATH} -maxdepth 1 -name ${CLUSTER_NAME}-ocp-cp-${n}.qcow2)
    if [[ $REMOTE_DISK_EXISTS = "${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-cp-${n}.qcow2" ]]; then
      echo -e "Disk for Control Plane #$n already exists on remote host...\n"
    else
      echo "Creating Control Plane #$n - Disk"
      ssh ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT} qemu-img create -f qcow2 ${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-cp-${n}.qcow2 ${CLUSTER_CONTROL_PLANE_DISK_GB}G
      sleep 2
    fi
    echo "Creating Control Plane #$n - VM"
    nohup virt-install ${LIBVIRT_LIKE_OPTIONS} --mac="${LIBVIRT_MAC_PREFIX}${n}0" --name=${CLUSTER_NAME}-ocp-cp-${n} --vcpus "sockets=${CLUSTER_CONTROL_PLANE_CPU_SOCKETS},cores=${CLUSTER_CONTROL_PLANE_CPU_CORES},threads=1" --memory="$(expr ${CLUSTER_CONTROL_PLANE_RAM_GB} \* 1024)" --disk "size=${CLUSTER_CONTROL_PLANE_DISK_GB},path=${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-cp-${n}.qcow2,cache=none,format=qcow2" &
    sleep 3
  done

  echo -e "Creating Application Node Infrastructure...\n"
  for ((n=1;n<=${CLUSTER_APP_NODE_COUNT};n++))
  do
    REMOTE_DISK_EXISTS=$(ssh ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT} find ${LIBVIRT_VM_PATH} -maxdepth 1 -name ${CLUSTER_NAME}-ocp-app-${n}.qcow2)
    if [[ $REMOTE_DISK_EXISTS = "${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-app-${n}.qcow2" ]]; then
      echo -e "Disk for Application Node #$n already exists on remote host...\n"
    else
      echo "Creating Application Node #$n - Disk"
      ssh ${LIBVIRT_USER}@${LIBVIRT_ENDPOINT} qemu-img create -f qcow2 ${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-app-${n}.qcow2 ${CLUSTER_APP_NODE_DISK_GB}G
      sleep 2
    fi
    echo "Creating Application Node #$n - VM"
    nohup virt-install --mac="${LIBVIRT_MAC_PREFIX}${n}1" --name=${CLUSTER_NAME}-ocp-app-${n} --vcpus "sockets=${CLUSTER_APP_NODE_CPU_SOCKETS},cores=${CLUSTER_APP_NODE_CPU_CORES},threads=1" --memory="$(expr ${CLUSTER_APP_NODE_RAM_GB} \* 1024)" --disk "size=${CLUSTER_APP_NODE_DISK_GB},path=${LIBVIRT_VM_PATH}/${CLUSTER_NAME}-ocp-app-${n}.qcow2,cache=none,format=qcow2" &
    sleep 3
  done
fi

if [[ $CLUSTER_TYPE = "SNO" ]]; then
  echo -e "Creating Single Node Infrastructure...\n"
fi