# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.network "private_network", ip: "192.168.66.9"

  # config.vm.network "public_network"

  config.vm.synced_folder "../vhosts/remedly/rm", "/home/vagrant/remedly/project", type: "nfs"
  config.vm.synced_folder "../vhosts/remedly/wp", "/home/vagrant/remedly/wp", type: "nfs"
  config.vm.synced_folder "../dumps", "/home/vagrant/dumps", type: "nfs"
  config.vm.synced_folder "../vhosts/remedly/rm/data", "/home/vagrant/project/data", :mount_options => ["dmode=777","fmode=777"]

  config.vm.provider "virtualbox" do |vb|
	vb.memory = "4096"
  end

  config.vm.provision :file, source: "vagrant/nginx/remedly.conf", destination: "remedly.conf"
  config.vm.provision :file, source: "vagrant/nginx/nginx.conf", destination: "nginx.conf"
  config.vm.provision :shell, path: "vagrant/bootstrap.sh"
end
