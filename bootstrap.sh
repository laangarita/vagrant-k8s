#!/usr/bin/env bash

# Update my VM
apt-get update

# Turn off swap
swapoff -a

# Comment out the swap partition
sed -i /swap/s/^/#/ /etc/fstab

# Update /etc/hosts file with your static IPs
grep -q "192.168.10" /etc/hosts
if [[ $? != 0 ]]; then
  sed -i '2 a 192.168.10.10   kubemstr01' /etc/hosts
  sed -i '3 a 192.168.10.20   kubenode01' /etc/hosts
fi

# Install Apache
apt-get install -y apache2

# Remove default Apache path and map to my synced host folder
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -sf /vagrant /var/www
fi

# Install Docker
apt -y install docker.io
usermod -aG docker vagrant

# Install K8s pre-reqs
apt -y install curl apt-transport-https

# Install K8s keyring
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add K8s repo
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Update APT cache
apt-get update -y

# Install Kubeadm, Kubelet, and Kubectl
apt-get install -y kubelet kubeadm kubectl

# Update the Kubernetes configuration
if grep -Fxq 'Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
then
  exit 0
else
  sed -i '/^ExecStart=$/i Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
fi

# Clean up environment
apt-get autoremove -y
apt-get autoclean -y
