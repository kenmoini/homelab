# Cluster Initialization

This folder contains some common things I deploy to a fresh OpenShift cluster, such as:

- Matrix-themed login page
- NFS StorageClass
- NFS backing for cluster registry
- RH Subscription Manager Entitlement (so you can do dnf installs with normal RHEL repos)

## Cheatsheet

***Must already be logged into the cluster!***

```bash
# Add the Matrix Login
cd matrix-login
./matrix-login/run.sh

# Add an NFS StorageClass
cd nfs-storageclass
./nfs-storageclass/run.sh

# Add an NFS store for the cluster registry
cd nfs-registry
./nfs-registry/run.sh

# RHSM entitlement
cd rh-reg-cluster-entitlement
# copy your entitlement certificate here to 'subscription.pem', see https://kenmoini.com/blog/using-nvidia-gpus-in-openshift/#3-entitle-the-cluster-with-the-red-hat-registry
./rh-reg-cluster-entitlement/run.sh
```