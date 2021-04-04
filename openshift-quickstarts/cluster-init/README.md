# Cluster Initialization

This folder contains some common things I deploy to a fresh OpenShift cluster, such as:

- Matrix-themed login page
- NFS StorageClass
- NFS backing for cluster registry

## Cheatsheet

***Must already be logged into the cluster!***

```bash
# Add the Matrix Login
./matrix-login/run.sh

# Add an NFS StorageClass
./nfs-storageclass/run.sh

# Add an NFS store for the cluster registry
./nfs-registry/run.sh
```