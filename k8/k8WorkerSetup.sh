cp  -f kubeadminitworker.yaml /etc/kubernetes/ 

# Join this worker node to the cluster
kubeadm join --config /etc/kubernetes/kubeadminitworker.yaml

# Repeat this process for the other worker nodes

