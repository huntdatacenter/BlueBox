servers = [
    {
        :name => "compute-1",
        :ip => "192.168.150.11"
    },
    {
        :name => "compute-2",
        :ip => "192.168.150.12"
    },
    # {
    #     :name => "compute-3",
    #     :ip => "192.168.150.13"
    # },
    # {
    #     :name => "compute-4",
    #     :ip => "192.168.150.14"
    # }
]

Vagrant.configure(2) do |config|
  servers.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.box = "bento/ubuntu-16.04"
      box.vm.hostname = opts[:name]
      # Entry ip
      box.vm.network "private_network", ip: opts[:ip]

      box.vm.provision "ansible" do |ansible|
        ansible.playbook = "dev/preprovision.yaml"
        ansible.groups = { "vagrant" => ["all"] }
      end

      box.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yaml"
      end

      box.vm.provider "virtualbox" do |v|
          v.name = opts[:name]
          v.memory = 512
          v.cpus = 1
      end
    end
  end
end
