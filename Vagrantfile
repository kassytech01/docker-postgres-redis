# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.vm.box = "coreos-alpha"
  config.vm.box_check_update = false
  config.vm.box_url = ["https://storage.googleapis.com/alpha.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"]

  config.vm.provider "virtualbox" do |vb|
    vb.check_guest_additions = false
    vb.functional_vboxsf     = false
    vb.memory = "512"
    vb.cpus = 1
  end

  # config.vm.synced_folder "./docker", "/tmp/docker", type: "nfs", :mount_options => ["nolock,vers=3,udp"]
  config.vm.synced_folder "./docker", "/tmp/docker", type: "nfs"

  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.network "forwarded_port", guest: 5432, host: 5432

  if Vagrant.has_plugin?("vagrant-vbguest") then
      config.vbguest.auto_update = false
  end

  # install docker-compose
  $get_compose = <<-'EOF'
    curl -L "https://github.com/docker/compose/releases/download/1.19.0/docker-compose-$(uname -s)-$(uname -m)" >  ~/docker-compose
    sudo mkdir -p /opt
    sudo mkdir -p /opt/bin
    sudo mv ~/docker-compose /opt/bin/docker-compose
    sudo chown root:root /opt/bin/docker-compose
    sudo chmod +x /opt/bin/docker-compose
  EOF
  config.vm.provision "shell", inline: $get_compose
  config.vm.provision "shell", inline: "docker-compose -f /tmp/docker/docker-compose.yml up -d", run: "always"
end
