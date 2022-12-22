#!/bin/bash

## Just change the VIRT_HOST, and run!
VIRT_HOST="serenity"
#VIRT_HOST="rocinante"
#VIRT_HOST="raza"

LOGF="k8s-virt.log"
echo "" > $LOGF

RAZA_LIBVIRT_HOST="192.168.42.40"
ROCINANTE_LIBVIRT_HOST="192.168.42.50"
SERENITY_LIBVIRT_HOST="192.168.42.55"

BRIDGE_IFACE="lanBridge"

BOOT_ISO_PATH="/mnt/nfs/isos/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
VM_PATH="/mnt/nfs/vms/${VIRT_HOST}"

CP_VCPUS="sockets=1,cores=4,threads=1"
AN_VCPUS="sockets=2,cores=4,threads=1"

CP_RAM="16384"
AN_RAM="65536"

MAC_PREFIX="54:52:00:42:00:"

SERENITY_QUADRO_DEV="--host-device=pci_0000_42_00_0 --host-device=pci_0000_42_00_1 --host-device=pci_0000_42_00_2 --host-device=pci_0000_42_00_3"
SERENITY_M40_DEV="--host-device=pci_0000_04_00_0"
ROCINANTE_M40_DEV="--host-device=pci_0000_04_00_0"

## SERENITY VMS
if [[ $VIRT_HOST == "serenity" ]]; then
  # Control Plane #1
  nohup virt-install -v --mac="${MAC_PREFIX}10" --name=${VIRT_HOST}-k8s-cp-1 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-cp-1.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # Control Plane #2
  nohup virt-install -v --mac="${MAC_PREFIX}20" --name=${VIRT_HOST}-k8s-cp-2 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cloud-init user-data="./control-plane-2.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-cp-2.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #1 - Normal
  nohup virt-install -v --mac="${MAC_PREFIX}40" --name=${VIRT_HOST}-k8s-app-1 --vcpus ${AN_VCPUS} --memory=${CP_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-1.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #2 - Quadro RTX 4000
  nohup virt-install -v --mac="${MAC_PREFIX}50" --name=${VIRT_HOST}-k8s-app-2-quadro --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-2.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot ${SERENITY_QUADRO_DEV} --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #3 - M40
  nohup virt-install -v --mac="${MAC_PREFIX}60" --name=${VIRT_HOST}-k8s-app-3-m40 --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-3.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot ${SERENITY_M40_DEV} --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
fi

## ROCINANTE VMS
if [[ $VIRT_HOST == "rocinante" ]]; then
  # Control Plane #3
  nohup virt-install -v --mac="${MAC_PREFIX}30" --name=${VIRT_HOST}-k8s-cp-3 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cloud-init user-data="./control-plane-3.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-cp-3.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #4 - Normal
  nohup virt-install -v --mac="${MAC_PREFIX}70" --name=${VIRT_HOST}-k8s-app-4 --vcpus ${AN_VCPUS} --memory=${CP_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-4.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #5 - Normal
  nohup virt-install -v --mac="${MAC_PREFIX}80" --name=${VIRT_HOST}-k8s-app-5 --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-5.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot --graphics spice,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
  # App Node #6 - M40
  nohup virt-install -v --mac="${MAC_PREFIX}90" --name=${VIRT_HOST}-k8s-app-6-m40 --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cloud-init user-data="./control-plane-1.cfg" --disk size=120,path=${VM_PATH}/${VIRT_HOST}-k8s-app-6.qcow2,cache=none,backing_store="${BOOT_ISO_PATH}" --os-variant=ubuntu20.04 --autostart --noautoconsole --noreboot ${ROCINANTE_M40_DEV} --graphics spice,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
  sleep 3
fi
