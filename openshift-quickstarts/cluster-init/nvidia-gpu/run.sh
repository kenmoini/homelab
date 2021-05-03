#!/bin/bash

# This script will set up an OpenShift cluster to use the NVidia GPU Operator

# Create the gpu-operator-resources namespace
oc new-project gpu-operator-resources

# Add Monitoring to Nvidia DCGM
oc label ns/gpu-operator-resources openshift.io/cluster-monitoring=true

# Install NFD Operator
echo "Installing the Node Feature Discovery Operator..."
oc apply -f deploy/nfd_sub.yaml

# Install the GPU Operator
echo "Installing the NVidia GPU Operator..."
oc apply -f deploy/gpu_sub.yaml

echo "Waiting 45 seconds while Operators install..."
sleep 45

echo "Deploying NFD Instance..."
oc apply -f deploy/nfd_instance.yaml

echo "Now deploy the Nvidia GPU Instance manually once the nodes are labeled and entitelment MachineConfig finishes rebooting all the nodes"

#echo "Waiting 45 seconds while NFD Instance labels nodes..."
#sleep 45

#echo "Deploying Nvidia GPU Instance..."
#oc apply -f deploy/gpu_instance.yaml