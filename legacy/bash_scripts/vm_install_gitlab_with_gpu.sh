#!/bin/bash

## Just change the VIRT_HOST, and run!
VIRT_HOST="serenity"
#VIRT_HOST="rocinante"
#VIRT_HOST="raza"

LOGF="virt.log"
echo "" > $LOGF

RAZA_LIBVIRT_HOST="192.168.42.40"
ROCINANTE_LIBVIRT_HOST="192.168.42.50"
SERENITY_LIBVIRT_HOST="192.168.42.55"

BRIDGE_IFACE="lanBridge"

ISO_PATH="/mnt/nfs/isos/rhel8.3.iso"
VM_PATH="/mnt/nfs/vms/${VIRT_HOST}"
VCPUS="sockets=1,cores=4,threads=1"
RAM="65536"

MAC_PREFIX="54:52:00:42:00:"

#SERENITY_QUADRO_DEV="--host-device=pci_0000_42_00_0 --host-device=pci_0000_42_00_1 --host-device=pci_0000_42_00_2 --host-device=pci_0000_42_00_3"
SERENITY_M40_DEV="--hostdev=04:00.0,address.type=pci,address.multifunction=on"
ROCINANTE_M40_DEV="--hostdev=04:00.0,address.type=pci,address.multifunction=on"
#ROCINANTE_M40_DEV="--host-device=pci_0000_04_00_0"

LIKE_OPTIONS="--memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi"

## SERENITY VMS
if [[ $VIRT_HOST == "serenity" ]]; then
  # Detatch Devices from host :'(
  #virsh nodedev-detach pci_0000_42_00_0
  #virsh nodedev-detach pci_0000_42_00_1
  #virsh nodedev-detach pci_0000_42_00_2
  #virsh nodedev-detach pci_0000_42_00_3
  virsh nodedev-detach pci_0000_04_00_0
  # GitLab GPU Node on Serenity
  nohup virt-install -v --mac="${MAC_PREFIX}66" ${LIKE_OPTIONS} --name=${VIRT_HOST}-gitlab-gpu --vcpus ${VCPUS} --memory=${RAM} --cdrom=${ISO_PATH} --disk size=240,path=${VM_PATH}/${VIRT_HOST}-gitlab-gpu.qcow2,cache=none --os-variant=rhel8.3 --events "on_reboot=restart" ${SERENITY_M40_DEV} --graphics vnc,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE},model=virtio &>>$LOGF &
fi

## ROCINANTE VMS
if [[ $VIRT_HOST == "rocinante" ]]; then
  # Detatch Devices from host :'(
  virsh nodedev-detach pci_0000_04_00_0
  # GitLab GPU Node on Roci
  nohup virt-install -v --mac="${MAC_PREFIX}96" ${LIKE_OPTIONS} --name=${VIRT_HOST}-gitlab-gpu --vcpus ${VCPUS} --memory=${RAM} --cdrom=${ISO_PATH} --disk size=240,path=${VM_PATH}/${VIRT_HOST}-gitlab-gpu.qcow2,cache=none --os-variant=rhel8.3 --events "on_reboot=restart" ${ROCINANTE_M40_DEV} --graphics vnc,listen=${ROCINANTE_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE},model=virtio &>>$LOGF &
  sleep 3
fi
