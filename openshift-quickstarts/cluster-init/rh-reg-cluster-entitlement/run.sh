#!/bin/bash

PEM_FILE="./subscription.pem"

echo "Templating manifest..."
sed  "s/BASE64_ENCODED_PEM_FILE/$(base64 -w 0 ${PEM_FILE})/g" 0003-cluster-wide-machineconfigs.yaml.template > 0003-cluster-wide-machineconfigs.yaml

echo "Creating secret..."
oc apply -f 0003-cluster-wide-machineconfigs.yaml