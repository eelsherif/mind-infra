# Installing the CPI

cp ./vsphere.conf  /etc/kubernetes/
cp ./cpi-global-secret.yaml /etc/kubernetes/

cd /etc/kubernetes
kubectl create configmap cloud-config --from-file=vsphere.conf --namespace=kube-system

kubectl create -f cpi-global-secret.yaml
cd -

kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-roles.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-role-bindings.yaml
kubectl apply -f https://github.com/kubernetes/cloud-provider-vsphere/raw/master/manifests/controller-manager/vsphere-cloud-controller-manager-ds.yaml

# check pods
kubectl get pods --namespace=kube-system

# check taint
kubectl describe nodes | egrep "Taints:|Name:"

# All the nodes should also have ProviderIDs after the CPI is installed. To check if some are missing, run the following:
kubectl get nodes -o json | jq '.items[]|[.metadata.name, .spec.providerID, .status.nodeInfo.systemUUID]'

#  Installing the Cloud Storage Interface (CSI)
cp ./csi-vsphere.conf  /etc/kubernets/

kubectl create secret generic vsphere-config-secret --from-file=csi-vsphere.conf --namespace=kube-system

# Create all the necessary for the CSI drive
kubectl apply -f https://github.com/kubernetes-sigs/vsphere-csi-driver/blob/master/manifests/v2.1.0/vsphere-7.0u1/deploy/vsphere-csi-controller-deployment.yaml
kubectl apply -f https://github.com/kubernetes-sigs/vsphere-csi-driver/blob/master/manifests/v2.1.0/vsphere-7.0u1/deploy/vsphere-csi-controller-deployment.yaml
kubectl apply -f https://github.com/kubernetes-sigs/vsphere-csi-driver/blob/master/manifests/v2.1.0/vsphere-7.0u1/deploy/vsphere-csi-node-ds.yaml

# verify that the CSI driver has been successfully deployed
kubectl get deployment --namespace=kube-system
kubectl get daemonsets vsphere-csi-node --namespace=kube-system

# verify that the vSphere CSI driver has been registered with Kubernetes
kubectl describe csidrivers

# verify that the CSINodes have been created
kubectl get CSINode

# Review cluster info

kubectl get nodes
kubectl cluster-info
