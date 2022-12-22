#!/bin/bash

echo "Downloading login..."
curl -s "https://raw.githubusercontent.com/kenmoini/openshift-web-console-customizations/master/competition/kenmoini/login.html" -O

echo "Creating secret..."
oc create secret generic matrix-login-template --from-file=login.html -n openshift-config

echo "Patching Cluster OAuths..."
oc patch OAuth.config.openshift.io cluster --patch '{"spec":{"templates":{"login":{"name":"matrix-login-template"}}}}' --type=merge

echo "Removing local login file..."
rm login.html