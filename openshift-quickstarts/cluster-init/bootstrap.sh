#!/bin/bash

cd matrix-login
./run.sh && cd ..

cd nfs-registry
./run.sh && cd ..

cd nfs-storageclass
./run.sh && cd ..

echo "Now run IDP and RHSM entitlement scripts (requires assets/input)"