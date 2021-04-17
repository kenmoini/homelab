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

BOOT_ISO_PATH="/mnt/nfs/isos/discovery_image_core-ocp.iso"
VM_PATH="/mnt/nfs/vms/${VIRT_HOST}"

CP_VCPUS="sockets=1,cores=4,threads=1"
AN_VCPUS="sockets=2,cores=4,threads=1"

CP_RAM="32768"
AN_RAM="65536"

MAC_PREFIX="54:52:00:42:00:"

SERENITY_QUADRO_DEV="--host-device=pci_0000_42_00_0 --host-device=pci_0000_42_00_1 --host-device=pci_0000_42_00_2 --host-device=pci_0000_42_00_3"
SERENITY_M40_DEV="--host-device=pci_0000_04_00_0"
ROCINANTE_M40_DEV="--host-device=pci_0000_04_00_0"
