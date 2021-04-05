#!/bin/bash

LIBVIRT_HOST="192.168.42.40"
BRIDGE_IFACE="lanBridge"

ISO_PATH="/mnt/nvme_7TB/nfs/isos/rhel8.3.iso"
VM_PATH="/mnt/nvme_7TB/nfs/vms/raza"

VCPUS="sockets=1,cores=1,threads=1"

RAM="4096"

virt-install -v --name=idm --vcpus ${VCPUS} --memory=${RAM} --cdrom=${ISO_PATH} --disk size=25,path=${VM_PATH}/idm.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --graphics spice,listen=${SERENITY_LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE}