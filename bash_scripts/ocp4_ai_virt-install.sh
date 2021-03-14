#!/bin/bash

OCP_AI_ISO_PATH="/mnt/nvme_2TB/isos/discovery_image_raza.iso"
VM_PATH="/mnt/nvme_2TB/VMs/ocp"

CP_VCPUS="sockets=1,cores=4,threads=1"
AN_VCPUS="sockets=1,cores=4,threads=1"

CP_RAM="16384"
AN_RAM="65536"

nohup virt-install --name=raza-ocp-cp-1 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-cp-1.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" &>/dev/null &
sleep 3
nohup virt-install --name=raza-ocp-cp-2 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-cp-2.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" &>/dev/null &
sleep 3
nohup virt-install --name=raza-ocp-cp-3 --vcpus ${CP_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-cp-3.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" &>/dev/null &
sleep 3

nohup virt-install --name=raza-ocp-app-1 --vcpus ${AN_VCPUS} --memory=${CP_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-app-1.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" &>/dev/null &
sleep 3
nohup virt-install --name=raza-ocp-app-2-quadro --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-app-2.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --host-device=pci_0000_81_00_0 --host-device=pci_0000_81_00_1 --host-device=pci_0000_81_00_2 --host-device=pci_0000_81_00_3 &>/dev/null &
sleep 3
nohup virt-install --name=raza-ocp-app-3-m40 --vcpus ${AN_VCPUS} --memory=${AN_RAM} --cdrom=${OCP_AI_ISO_PATH} --disk size=120,path=${VM_PATH}/raza-ocp-app-3.qcow2 --os-variant=rhel8.3 --autostart --noautoconsole --events "on_reboot=restart" --host-device=pci_0000_41_00_0 &>/dev/null &