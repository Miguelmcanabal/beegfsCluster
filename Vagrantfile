Vagrant.configure(2) do |config|

  config.vm.box = "geerlingguy/centos7"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
  end

  config.vm.define "master", primary: true do |master|
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "192.168.44.1"
    master.disksize.size = '2GB'
    master.vm.provider :virtualbox do |prov|
        prov.cpus = "1"
        prov.memory = "1024"

        end
      master.vm.provision "shell", inline: <<-SHELL
        yum update -y
        yum install -y epel-release
        yum --enablerepo=extras install -y epel-release
        yum install -y python-pip
        pip install ansible==2.5.0
        mkdir -p /etc/ansible
        cp /vagrant/ansible/ansible.cfg /etc/ansible
        ansible-galaxy install stackhpc.beegfs
    SHELL
    end
  

  config.vm.define "mgmt" do |config|
    config.vm.hostname = "mgmt"
    config.vm.network "private_network", ip: "192.168.44.10"
  end

    config.vm.define "meta" do |config|
    config.vm.hostname = "meta"
    config.vm.network "private_network", ip: "192.168.44.20"
     config.vm.provider :virtualbox do |prov|
    filename = "./disks/#{config.vm.hostname}-disk1.vmdk"
    unless File.exist?(filename)
      prov.customize ["createmedium", "disk", "--filename", filename, "--size", 5 * 1024]
     end
     prov.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", filename]
    filename = "./disks/#{config.vm.hostname}-disk2.vmdk"
    unless File.exist?(filename)
      prov.customize ["createmedium", "disk", "--filename", filename, "--size", 5 * 1024]
     end
     prov.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 1, "--type", "hdd", "--medium", filename]
  
   end
  end



  config.vm.define "storage" do |config|
    config.vm.hostname = "storage"
    config.vm.network "private_network", ip: "192.168.44.30"
    config.vm.provision "shell", inline: <<-SHELL
    SHELL
    config.vm.provider :virtualbox do |prov|
    filename = "./disks/#{config.vm.hostname}-disk1.vmdk"
    unless File.exist?(filename)
      prov.customize ["createmedium", "disk", "--filename", filename, "--size", 10 * 1024]
     end
     prov.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", filename]
      
    filename = "./disks/#{config.vm.hostname}-disk2.vmdk"
    unless File.exist?(filename)
      prov.customize ["createmedium", "disk", "--filename", filename, "--size", 10 * 1024]
     end
     prov.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 1, "--type", "hdd", "--medium", filename]
    end
  end

  config.vm.define "client" do |config|
    config.vm.hostname = "client"
    config.vm.network "private_network", ip: "192.168.44.40" 
    config.vm.provision "shell", inline: <<-SHELL
    sudo yum update -y
    sudo yum install -y kernel-devel
    sudo sed -i 's/.*SELINUX=enforcing.*/SELINUX=disabled/' /etc/selinux/config
    sudo reboot

    SHELL
  end

  config.vm.define "admon" do |config|
    config.vm.hostname = "admon"
    config.vm.network "private_network", ip: "192.168.44.50" 
    config.vm.provision "shell", inline: <<-SHELL
     sudo yum -y groupinstall "GNOME Desktop"
     sudo systemctl set-default graphical.target
     sudo systemctl start graphical.target
    SHELL
  end
  config.vm.provision "shell", path: "./provisioning/bootstrap.sh" do |script|
  end
end