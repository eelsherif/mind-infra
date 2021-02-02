#  Install updates

yum update -y

# Setup Kubernetes Repo

cp kubernetes.repo  /etc/yum.repos.d/

cp -f ./kubernetes.repo  /etc/yum.repos.d

yum install -y kubeadm docker

# Stop firewall/selinux

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Create system services

systemctl enable kubelet
systemctl start kubelet

# Enable IP forwarding or iptables. Update below lines in /etc/sysctl.conf

tee /etc/sysctl.d/k8s.conf >/dev/null <<EOF
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
EOF

sysctl -p

# vm tools
# A number of CNI implementations (such Calico, Antrea, and etc) introduce networking artifacts that interfere with
# the normal operation of vSphere's internal reporting for network/device interfaces.
# To address this issue, an exclude-nics filter for VMTools needs to be applied in order to prevent
# these artifacts from getting reported to vSphere and causing problems with network/device associations to vNICs on virtual machines.
# see https://github.com/kubernetes/cloud-provider-vsphere/blob/master/docs/book/known_issues.md
 
tee -a /etc/vmware-tools/tools.conf >/dev/null <<EOF
 
[guestinfo]
primary-nics=eth0
exclude-nics=antrea-*,cali*,ovs-system,br*,flannel*,veth*,docker*,virbr*,vxlan_sys_*,genev_sys_*,gre_sys_*,stt_sys_*,????????-??????
EOF
 
systemctl restart vmtoolsd
