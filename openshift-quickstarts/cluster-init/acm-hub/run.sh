#!/bin/bash

# This script will set up an OpenShift cluster to use the ACM Operator

# Install Advanced Cluster Management Operator
echo "Installing the Advanced Cluster Management Operator..."
oc apply -f 01-project.yaml
oc apply -f 02-operatorgroup.yaml
oc apply -f 03-subscription.yaml

echo "Waiting 120 seconds while Operator install..."
sleep 120

echo "Deploying MultiClusterHub..."
oc apply -f 04-multiclusterhub.yaml