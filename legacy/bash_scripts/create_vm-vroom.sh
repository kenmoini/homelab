#!/bin/bash

## Just change the VIRT_HOST, and run!
VM_NAME="vroom"
BRIDGE_IFACE="bridge0"

ISO_PATH="/mnt/isos/Windows10Pro64bit.iso"
VIRT_IO_ISO_PATH="/mnt/isos/virtio-win.iso"
VM_PATH="/var/lib/libvirt/images/"

VCPUS="sockets=1,cores=6,threads=1"
RAM="32772"

SUKI_RX_DEV="--hostdev=21:00.0,address.type=pci,address.multifunction=on --hostdev=21:00.1,address.type=pci,address.multifunction=on"

LIKE_OPTIONS="-v --memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi --cdrom=${ISO_PATH} --disk ${VIRT_IO_ISO_PATH},device=cdrom,bus=sata --os-variant=win10 --os-type=windows --events on_reboot=restart --network bridge=${BRIDGE_IFACE},model=virtio"

# Detatch Devices from host :'(
virsh nodedev-detach pci_0000_21_00_0
virsh nodedev-detach pci_0000_21_00_1

# Build VM
virt-install --name=${VM_NAME} --vcpus ${VCPUS} --memory=${RAM} --disk size=250,path=${VM_PATH}/${VM_NAME}.qcow2,cache=none ${SUKI_RX_DEV} --graphics vnc,listen=0.0.0.0,tlsport=-1,defaultMode='insecure' ${LIKE_OPTIONS}