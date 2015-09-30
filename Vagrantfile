# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  # https://docs.vagrantup.com.
  # boxes at https://atlas.hashicorp.com/search.
  
  config.vm.box = "ubuntu/vivid64"
  
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = false # !required for base box to use Vagrant's insecure public private key

  config.vm.define 'ubox', primary: true do |box|
    box.vm.hostname = 'ubox'
    box.vm.provision 'shell', privileged: false, inline: '/vagrant/ubox/compile'
    box.vm.provision 'shell', privileged: false, path: 'ubox/install.bash'
  end

  config.vm.define 'rbase', autostart: false do |box|
    box.vm.hostname = 'rbase'
    box.vm.box = "ubox"
    box.vm.provision 'shell', privileged: false, path: 'rbenv-pluger/boot/ruby-build-essential'
  end

  config.vm.define 'rbox', autostart: false do |box|
    box.vm.hostname = 'rbox'
    box.vm.box = "rbase"
    box.vm.provision 'shell', privileged: false, inline: '/vagrant/rbox/compile', name: 'compiling'
    box.vm.provision 'shell', privileged: false, inline: '/vagrant/rbox/install.bash', name: 'installing'
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.memory = "1024"
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end
end
