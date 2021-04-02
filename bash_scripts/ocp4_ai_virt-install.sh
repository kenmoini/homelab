#!/bin/bash

LOGF="virt.log"
echo "" > $LOGF

LIBVIRT_HOST="192.168.42.55"
BRIDGE_IFACE="lanBridge"

OCP_AI_ISO_PATH="/opt/discovery_image_roci-ocp.iso"
VM_PATH="/mnt/nfs/ocp"

CP_VCPUS="sockets=1,cores=4,threads=1"
AN_VCPUS="sockets=1,cores=4,threads=1"

CP_RAM="32768"
AN_RAM="65536"

MAC_PREFIX="54:52:00:42:00:"

SERENITY_QUADRO_DEV="--host-device=pci_0000_42_00_0 --host-device=pci_0000_42_00_1 --host-device=pci_0000_42_00_2 --host-device=pci_0000_42_00_3"
SERENITY_M40_DEV="--host-device=pci_0000_04_00_0"
ROCINANTE_M40_DEV="--host-device=pci_0000_04_00_0"

nohup virt-install -v --mac="${MAC_PREFIX}10" --name=serenity-ocp-cp-1 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-cp-1.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
sleep 3
nohup virt-install -v --mac="${MAC_PREFIX}20" --name=serenity-ocp-cp-2 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-cp-2.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
sleep 3
nohup virt-install -v --mac="${MAC_PREFIX}30" --name=serenity-ocp-cp-3 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-cp-3.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
sleep 3

nohup virt-install -v --mac="${MAC_PREFIX}40" --name=serenity-ocp-app-1 --vcpus ${AN_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-app-1.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
sleep 3
nohup virt-install -v --mac="${MAC_PREFIX}50" --name=serenity-ocp-app-2-quadro --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-app-2.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" ${SERENITY_QUADRO_DEV} --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &
sleep 3
nohup virt-install -v --mac="${MAC_PREFIX}60" --name=serenity-ocp-app-3-m40 --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/serenity-ocp-app-3.qcow2,cache=none --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" ${SERENITY_M40_DEV} --graphics spice,listen=${LIBVIRT_HOST},tlsport=,defaultMode='insecure' --network bridge=${BRIDGE_IFACE} &>>$LOGF &