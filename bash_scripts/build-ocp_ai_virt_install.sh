#!/bin/bash

## Just change the VIRT_HOST, and run!
VIRT_HOST="serenity"
#VIRT_HOST="rocinante"
#VIRT_HOST="raza"

LOGF="build-ocp.virt-install.log"
echo "" > $LOGF

RAZA_LIBVIRT_HOST="192.168.42.40"
ROCINANTE_LIBVIRT_HOST="192.168.42.50"
SERENITY_LIBVIRT_HOST="192.168.42.55"

BRIDGE_IFACE="lanBridge"

ISO_PATH="/mnt/nfs/isos/discovery_image_build-ocp.iso"
VM_PATH="/mnt/nfs/vms/${VIRT_HOST}"

CP_VCPUS="sockets=1,cores=4,threads=1"
CP_RAM="24576"

APP_VCPUS="sockets=1,cores=24,threads=1"
APP_RAM="65536"

MAC_PREFIX="54:52:00:42:01:"

SERENITY_QUADRO_DEV="--hostdev=42:00.0,address.type=pci,address.multifunction=on --hostdev=42:00.1,address.type=pci,address.multifunction=on --hostdev=42:00.2,address.type=pci,address.multifunction=on --hostdev=42:00.3,address.type=pci,address.multifunction=on"
SERENITY_M40_DEV="--hostdev=04:00.0,address.type=pci,address.multifunction=on"
ROCINANTE_M40_DEV="--hostdev=04:00.0,address.type=pci,address.multifunction=on"
#ROCINANTE_M40_DEV="--host-device=pci_0000_04_00_0" # alt/old format

LIKE_OPTIONS="-v --memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi --cdrom=${ISO_PATH} --os-variant=rhel8.3 --events on_reboot=restart --network bridge=${BRIDGE_IFACE},model=virtio"

## SERENITY VMS
if [[ $VIRT_HOST == "serenity" ]]; then
  # Detatch Devices from host :'(
  #virsh nodedev-detach pci_0000_42_00_0
  #virsh nodedev-detach pci_0000_42_00_1
  #virsh nodedev-detach pci_0000_42_00_2
  #virsh nodedev-detach pci_0000_42_00_3
  #virsh nodedev-detach pci_0000_04_00_0
  # Control Plane #1
  nohup virt-install --mac="${MAC_PREFIX}12" --name=${VIRT_HOST}-build-ocp-cp-1 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --disk size=120,path=${VM_PATH}/${VIRT_HOST}-build-ocp-cp-1.qcow2,cache=none --graphics vnc,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
  sleep 3
  # Control Plane #3
  nohup virt-install --mac="${MAC_PREFIX}32" --name=${VIRT_HOST}-build-ocp-cp-3 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --disk size=120,path=${VM_PATH}/${VIRT_HOST}-build-ocp-cp-3.qcow2,cache=none --graphics vnc,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
  sleep 3
  # App Node #1 - Normal
  nohup virt-install --mac="${MAC_PREFIX}42" --name=${VIRT_HOST}-build-ocp-app-1 --vcpus ${APP_VCPUS} --memory=${APP_RAM} --disk size=120,path=${VM_PATH}/${VIRT_HOST}-build-ocp-app-1.qcow2,cache=none --graphics vnc,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
  sleep 3
  # App Node + M40 GPU on Serenity, used in GitLab normally
  #nohup virt-install --mac="${MAC_PREFIX}62" --name=${VIRT_HOST}-build-ocp-app-2-m40 --vcpus ${APP_VCPUS} --memory=${APP_RAM} --disk size=240,path=${VM_PATH}/${VIRT_HOST}-build-ocp-app-2-m40.qcow2,cache=none ${SERENITY_M40_DEV} --graphics vnc,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
fi

## ROCINANTE VMS
if [[ $VIRT_HOST == "rocinante" ]]; then
  # Detatch Devices from host :'(
  virsh nodedev-detach pci_0000_04_00_0
  # Control Plane #2
  nohup virt-install --mac="${MAC_PREFIX}22" --name=${VIRT_HOST}-build-ocp-cp-2 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --disk size=120,path=${VM_PATH}/${VIRT_HOST}-build-ocp-cp-2.qcow2,cache=none --graphics vnc,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
  sleep 3
  # App Node + M40 GPU on Roci
  nohup virt-install --mac="${MAC_PREFIX}92" --name=${VIRT_HOST}-build-ocp-app-2-m40 --vcpus ${APP_VCPUS} --memory=${APP_RAM} --disk size=240,path=${VM_PATH}/${VIRT_HOST}-build-ocp-app-2-m40.qcow2,cache=none ${ROCINANTE_M40_DEV} --graphics vnc,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
  sleep 3
fi
