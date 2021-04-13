#!/bin/bash

BIND_PASSWORD=$1

oc create secret generic ldap-bind-password --from-literal=bindPassword=${BIND_PASSWORD} -n openshift-config

oc create configmap ldap-ca --from-file=ca.crt=cert.pem -n openshift-config

oc apply -f ldap-idp.yaml

sed "s/SOME_SECURE_PASSWORD/${BIND_PASSWORD}/g" ldap-sync.yaml.template > ldap-sync.yaml

oc adm groups sync --sync-config=ldap-sync.yaml --confirm

oc adm policy add-cluster-role-to-group cluster-admin admins
oc adm policy add-cluster-role-to-group cluster-admin labadmins