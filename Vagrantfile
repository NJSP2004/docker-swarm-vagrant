
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  nodes = {
    "master" => { ip: "192.168.56.10", role: "master" },
    "node01" => { ip: "192.168.56.11", role: "worker" },
    "node02" => { ip: "192.168.56.12", role: "worker" },
    "node03" => { ip: "192.168.56.13", role: "worker" }
  }

  nodes.each do |name, settings|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: settings[:ip]

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      node.vm.provision "shell",
        path: "scripts/install-docker.sh"

      node.vm.provision "shell",
        path: "scripts/configure-swarm.sh",
        args: [settings[:role], settings[:ip]]
    end
  end
end
