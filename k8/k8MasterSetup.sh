# initialize the cluster
kubeadm init --config /etc/kubernetes/kubeadminit.yaml --upload-certs

# Setup kubectl by following executing the following as your regular user:
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Make sure that all nodes were tainted before continuing to install the CPI. I verified that by executing:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Export the master configuration and saved it into discovery.yaml
kubectl get configmap cluster-info -o jsonpath='{.data.kubeconfig}' > discovery.yaml

