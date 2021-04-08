#!/bin/bash

BIND_PASSWORD=$1

oc create secret generic labdap-bind-password --from-literal=bindPassword=${BIND_PASSWORD} -n openshift-config

oc create configmap labdap-ca --from-file=ca.crt=cert.pem -n openshift-config

sed "s/SOME_SECURE_PASSWORD/${BIND_PASSWORD}/g" ldap-sync.yaml.template > lab-sync.yaml

oc adm groups sync --sync-config=ldap-sync.yaml --confirm