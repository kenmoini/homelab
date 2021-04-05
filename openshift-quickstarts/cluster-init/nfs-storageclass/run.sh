#/bin/bash

export $(grep -v '^#' env | xargs)

echo "*******************************************"
echo "Configuring Dynamic NFS Storage Class"
echo "*******************************************"

echo "Creating project..."
oc new-project $NAMESPACE_NFS

echo "Applying RBAC..."
oc apply -f deploy/rbac.yaml

sleep 3

echo "Applying security constraints..."
oc adm policy add-role-to-user use-scc-hostmount-anyuid system:serviceaccount:$NAMESPACE_NFS:nfs-client-provisioner
oc create role use-scc-hostmount-anyuid --verb=use --resource=scc --resource-name=hostmount-anyuid -n $NAMESPACE_NFS
oc adm policy add-role-to-user use-scc-hostmount-anyuid system:serviceaccount:$NAMESPACE_NFS:nfs-client-provisioner
oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE_NFS:nfs-client-provisioner

sleep 3

echo "Applying manifests..."
oc apply -f deploy/deployment.yaml
oc apply -f deploy/storageclass.yaml

#oc process -f template.yaml --param-file=env | oc create -f -

#oc adm policy add-scc-to-user hostmount-anyuid -n ${NAMESPACE_NFS} -z nfs-client-provisioner
#oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$NAMESPACE_NFS:nfs-client-provisioner