# Vagrant K8s 2 node cluster setup #

box_image = "geerlingguy/ubuntu1604"

Vagrant.configure("2") do |config|
  config.vm.define "k8mstr" do |k8mstr|
    k8mstr.vm.box = box_image
    k8mstr.vm.network "private_network", ip: "192.168.10.10"
    k8mstr.vm.hostname = "kubemstr01"
    k8mstr.vm.network "forwarded_port", guest: 80, host: 1234
    k8mstr.vm.provider :virtualbox do |vb|
      vb.cpus = "2"
      vb.memory = "4096"
      vb.name = "kubemstr01"
    end
 
    k8mstr.vm.provision "shell", inline: <<-SHELL
      sudo echo "192.168.10.10 kubemstr01" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 kubewrkr01" | sudo tee -a /etc/hosts
    SHELL
    config.vm.provision :shell, path: "bootstrap.sh"
  end

  config.vm.define "k8wrkr" do |k8wrkr|
    k8wrkr.vm.box = box_image
    k8wrkr.vm.network "private_network", ip: "192.168.10.20"
    k8wrkr.vm.hostname = "kubewrkr01"
    k8wrkr.vm.network "forwarded_port", guest: 80, host: 2345
    k8wrkr.vm.provider :virtualbox do |vb|
      vb.cpus = "2"
      vb.memory = "2048"
      vb.name = "kubewrkr01"
    end
 
    k8wrkr.vm.provision "shell", inline: <<-SHELL
      sudo echo "192.168.10.10 kubemstr01" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 kubewrkr01" | sudo tee -a /etc/hosts
    SHELL
    config.vm.provision :shell, path: "bootstrap.sh"
  end
end
