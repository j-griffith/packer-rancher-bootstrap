#!/bin/bash

# modeprobe, netfilter, sysctl

modprobe overlay
modprobe br_netfilter

echo -e "overlay\nbr_netfilter" | sudo tee -a /etc/modules-load.d/kubernetes.conf

echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

sysctl -p


# Set iptables to legacy mode, see https://github.com/kubernetes/kubernetes/issues/71305
update-alternatives --set iptables /usr/sbin/iptables-legacy

# kubernetes

KUBERNETES_PKG_VERSION="${KUBERNETES_VERSION}-00"

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Use Docker runtime, rather than containerd
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
apt-get update
apt-get install -y docker-ce

# Setup Docker daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d


# cni, kubeadm

apt-get update

if [ $KUBERNETES_VERSION != "1.13.7" ]
then
    apt-get install -y kubernetes-cni=0.7.*
else
    apt-get install -y kubernetes-cni=0.6.*
fi

apt-get install -y \
    kubelet=${KUBERNETES_PKG_VERSION} \
    kubeadm=${KUBERNETES_PKG_VERSION}

# Mark these packages as fixed so they stay at the same version on a run of apt-get upgrade
# See NKS-3011
apt-mark hold kubelet kubeadm kubectl kubernetes-cni

kubeadm config images pull --kubernetes-version=${KUBERNETES_VERSION}
