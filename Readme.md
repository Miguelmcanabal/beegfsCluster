

# BeeGFS Cluster Provision



## Vagrant deploy
   vagrant up
   vagrant ssh master

## Ansible Playbooks

Once in master, execute:

	/vagrant/provisioning/setupSSH.sh vagrant
	cd /vagrant/ansible/
	ansible-galaxy install ahharu.mdadm
	ansible-playbook oss.yml -i inventory
	ansible-playbook main.yml -i inventory



Now, you can try some MPI.io stuff with IOR library.

Note: Due distro problems, mdadm is not recognizing Centos 7, so u have to execute oss.yml again if it fails.