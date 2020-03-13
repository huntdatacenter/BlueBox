# IAAS-scibox-example

Example research setup for running workload over multiple IAAS nodes

## Setup on home (master)

Setup local environment on your home server:

```
sudo apt install parallel pssh python3-venv python3-pip
git clone https://github.com/huntdatacenter/IAAS-scibox-example.git
cd IAAS-scibox-example
python3 -m venv env
source env/bin/activate
pip3 install -r files/requirements.txt
```

## Setup on IAAS nodes (workers)

Before using your IAAS nodes update the node list in `hosts.txt` in GNU parallel format.
Where `N` is number of CPUs available, ubuntu is a user, and `node-X-IP` should be replace
with IPs of nodes.

```
N/ubuntu@node-1-IP
N/ubuntu@node-2-IP
...
```

### Provisioning

If you need to setup SSH keys run a playbook with tag `setupkeys`, which will generate a key
and try to connect to nodes and place the public key. Otherwise you should place your private
key to `files/cluster-ssh-key` for Ansible to use it.

```
source env/bin/activate  # Make sure you env is active
ansible-playbook ansible.yaml -t setupkeys
```

Then follow with installation of remote environments and dependencies for all nodes.
Playbook includes:
- python dependencies
- tabix
- bcftools

```
source env/bin/activate  # Make sure you env is active
ansible-playbook playbook.yaml
```

## Parallel workload

To run a workload make sure that your own scripts and data are in place on remote nodes.
Starting a workload on nodes:

```
ssh-add files/cluster-ssh-key
cat tasks.txt | parallel --sshloginfile hosts.txt -j1 {}
```

## Simulate on local computer (notebook)

Requires Vagrant, VirtualBox, and Ansible to be installed. Vagrant will setup virtual
machines that will be provisioned with our Ansible playbook.

```
vagrant up
vagrant status

# Test SSH access
vagrant ssh compute-1
```
