#!/bin/bash

# This script will set up an OpenShift cluster to use the NVidia GPU Operator

# Install NFD Operator
echo "Installing the Node Feature Discovery Operator..."
oc apply -f deploy/nfd_sub.yaml

echo "Waiting 15 seconds while Operator installs..."
sleep 20

oc apply -f deploy/nfd_instance.yaml

# Create the gpu-operator-resources namespace
echo "Installing the NVidia GPU Operator..."
oc new-project gpu-operator-resources

# Add Monitoring to Nvidia DCGM
oc label ns/gpu-operator-resources openshift.io/cluster-monitoring=true

# Install the GPU Operator
oc apply -f deploy/gpu_sub.yaml

echo "Waiting 15 seconds while Operator installs..."
sleep 20

oc apply -f deploy/gpu_instance.yaml