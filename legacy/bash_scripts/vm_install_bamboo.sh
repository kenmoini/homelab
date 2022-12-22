#!/bin/bash

LIBVIRT_HOST="192.168.42.40"
BRIDGE_IFACE="containerLANbr0"

ISO_PATH="/mnt/nvme_7TB/nfs/isos/rhel8.3.iso"
VM_PATH="/mnt/nvme_7TB/nfs/vms/raza"

VCPUS="sockets=1,cores=2,threads=1"

RAM="8192"

virt-install -v --name=bamboo --vcpus ${VCPUS} --memory=${RAM} --cdrom=${ISO_PATH} --disk size=60,path=${VM_PATH}/bamboo.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --graphics vnc,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE}

