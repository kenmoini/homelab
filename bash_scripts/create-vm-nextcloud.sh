#!/bin/bash

VIRT_HOST="suki"
VM_NAME="nextcloud"

BRIDGE_IFACE="bridge0"

ISO_PATH="/mnt/fastAndLoose/nfs/isos/ubuntu-20.04.3-live-server-amd64.iso"
VM_PATH="/mnt/fastAndLoose/nfs/vms/${VIRT_HOST}"

VCPUS="sockets=1,cores=2,threads=1"
RAM="4096"

LIKE_OPTIONS="-v --memballoon none --cpu host-passthrough --autostart --noautoconsole --virt-type kvm --features kvm_hidden=on --controller type=scsi,model=virtio-scsi --cdrom=${ISO_PATH} --os-variant=ubuntu20.04 --events on_reboot=restart --network bridge=${BRIDGE_IFACE},model=virtio"

# Build VM
virt-install --name=${VM_NAME} --vcpus ${VCPUS} --memory=${RAM} --disk size=60,path=${VM_PATH}/${VM_NAME}.qcow2,cache=none --graphics vnc,listen=0.0.0.0,tlsport=,defaultMode='insecure' ${LIKE_OPTIONS}