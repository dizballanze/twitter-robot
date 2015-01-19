Vagrant.configure(2) do |config|
  # Virtual machine parameters
  config.vm.box = "chef/debian-7.6"
  config.vm.network "private_network", ip: "10.1.1.97"
  config.vm.synced_folder ".", "/home/vagrant/proj"
  config.vm.hostname = "twitterbot"
  config.vm.post_up_message = "twitterbot dev server successfuly started.
    connect over ssh with `vagrant ssh`"
  # Set box name
  config.vm.define :twitterbot_vagrant do |t|
  end
  # Virtualbox specific parameters
  config.vm.provider "virtualbox" do |v|
    v.name = "twitterbot_vagrant"
    v.memory = 1024
    v.cpus = 2
  end
  # Provisioning with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/playbook.yml"
  end
end