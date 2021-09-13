#!/bin/bash

## Just change the VIRT_HOST, and run!
VIRT_HOST="suki"
VM_NAME="vroom"

LOGF="${VM_NAME}.virt-install.log"
echo "" > $LOGF

RAZA_LIBVIRT_HOST="192.168.42.40"
SUKI_LIBVIRT_HOST="192.168.42.46"

BRIDGE_IFACE="bridge0"

ISO_PATH="/mnt/fastAndLoose/nfs/isos/Windows10Pro64bit.iso"
VM_PATH="/mnt/fastAndLoose/nfs/vms/${VIRT_HOST}"

VCPUS="sockets=1,cores=4,threads=1"
RAM="16386"

MAC_PREFIX="54:52:00:42:07:"
SUKI_RX_DEV="--hostdev=21:00.0,address.type=pci,address.multifunction=on --hostdev=21:00.1,address.type=pci,address.multifunction=on"

LIKE_OPTIONS="-v --memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi --cdrom=${ISO_PATH} --os-variant=win7 --events on_reboot=restart --network bridge=${BRIDGE_IFACE},model=virtio"

## SUKI VMS
if [[ $VIRT_HOST == "suki" ]]; then
  # Detatch Devices from host :'(
  virsh nodedev-detach pci_0000_21_00_0
  virsh nodedev-detach pci_0000_21_00_1
  
  # Build VM
  nohup virt-install --mac="${MAC_PREFIX}69" --name=${VIRT_HOST}-${VM_NAME} --vcpus ${VCPUS} --memory=${RAM} --disk size=600,path=${VM_PATH}/${VIRT_HOST}-${VM_NAME}.qcow2,cache=none ${SUKI_RX_DEV} --graphics vnc,listen=${SUKI_LIBVIRT_HOST},tlsport=,defaultMode='insecure' ${LIKE_OPTIONS} &>>$LOGF &
fi