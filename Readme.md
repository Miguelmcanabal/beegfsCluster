

# BeeGFS Cluster Provision



## Vagrant deploy
   vagrant up
   vegrant ssh master

## Ansible Playbooks

Once in master, execute:

	/vagrant/provisioning/setupSSH.sh vagrant
	cd /vagrant/ansible/
	ansible-galaxy install ahharu.mdadm
	ansible-playbook oss.yml -i inventory
	ansible-playbook main.yml -i inventory



Now, you can try some MPI.io stuff with IOR library.