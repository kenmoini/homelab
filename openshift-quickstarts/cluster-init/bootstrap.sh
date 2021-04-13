#!/bin/bash

cd idp-ldap
./run.sh $1 && cd ..

cd matrix-login
./run.sh && cd ..

cd nfs-registry
./run.sh && cd ..

cd nfs-storageclass
./run.sh && cd ..

echo "Now run RHSM entitlement scripts (requires assets/input)"