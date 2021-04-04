 #/bin/bash

oc process -f template.yaml --param-file=env | oc create -f -

sleep 10

oc patch configs.imageregistry.operator.openshift.io cluster --type='json' -p='[{"op": "replace", "path": "/spec/managementState", "value": "Managed" },{"op": "remove", "path": "/spec/storage" },{"op": "add", "path": "/spec/storage", "value": {"pvc":{"claim": ""}}}]'