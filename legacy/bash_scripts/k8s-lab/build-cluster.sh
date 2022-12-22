#!/bin/bash

LOGF="virt.log"
echo "" > $LOGF

qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-cp-1.qcow2 40G
qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-cp-2.qcow2 40G
qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-cp-3.qcow2 40G
qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-app-1.qcow2 80G
qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-app-2.qcow2 80G
#qemu-img create -f qcow2 /mnt/nvme_2TB/VMs/k8s-app-3.qcow2 80G

nohup virsh create ./kvm-xmls/k8s-cp-1.xml &>>$LOGF &
sleep 3
nohup virsh create ./kvm-xmls/k8s-cp-2.xml &>>$LOGF &
sleep 3
nohup virsh create ./kvm-xmls/k8s-cp-3.xml &>>$LOGF &
sleep 3
nohup virsh create ./kvm-xmls/k8s-app-1.xml &>>$LOGF &
sleep 3
nohup virsh create ./kvm-xmls/k8s-app-2.xml &>>$LOGF &
sleep 3
#nohup virsh create ./kvm-xmls/k8s-app-3.xml &>>$LOGF &
#sleep 3