#!/bin/bash

rm -rf /mnt/nvme_2TB/VMs/k8s-cp-1.qcow2
rm -rf /mnt/nvme_2TB/VMs/k8s-cp-2.qcow2
rm -rf /mnt/nvme_2TB/VMs/k8s-cp-3.qcow2
rm -rf /mnt/nvme_2TB/VMs/k8s-app-1.qcow2
rm -rf /mnt/nvme_2TB/VMs/k8s-app-2.qcow2
rm -rf /mnt/nvme_2TB/VMs/k8s-app-3.qcow2

virsh destroy k8s-cp-1
virsh destroy k8s-cp-2
virsh destroy k8s-cp-3
virsh destroy k8s-app-1
virsh destroy k8s-app-2
virsh destroy k8s-app-3

virsh undefine k8s-cp-1
virsh undefine k8s-cp-2
virsh undefine k8s-cp-3
virsh undefine k8s-app-1
virsh undefine k8s-app-2
virsh undefine k8s-app-3
