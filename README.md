# IAAS-scibox-example

Example research setup for running workload over multiple IAAS nodes

## Setup on home (master)

Install dependencies on your home server:

```
sudo apt install parallel pssh python3-venv python3-pip
```

Get this repository:
```
git clone https://github.com/huntdatacenter/IAAS-scibox-example.git
cd IAAS-scibox-example
```

Setup python environment:
```
python3 -m venv env
source env/bin/activate
pip3 install -r files/requirements.txt
```

When using ansible make sure your python environment is activated:
```
source env/bin/activate
```

## List of nodes - inventory

Before using your IAAS nodes create the node list in `hosts.txt`.
```
vim hosts.txt
```

Follow GNU parallel format. Where `N` is number of CPUs available, ubuntu is a user, and `node-X-IP` should be replace
with IPs of nodes.

```
N/ubuntu@node-1-IP
N/ubuntu@node-2-IP
...
N/ubuntu@node-X-IP
```

Example hosts.txt:
```
8/ubuntu@192.168.150.11
8/ubuntu@192.168.150.12
```

### Provisioning environment on IAAS nodes (workers)

If you need to setup SSH keys run a playbook with tag `setupkeys`, which will generate a key
and try to connect to nodes and place the public key. Otherwise you should place your private
key to `files/cluster-ssh-key` for Ansible to use it.

```
ansible-playbook ansible.yaml -t setupkeys
```

Then follow with installation of remote environments and dependencies for all nodes.
Playbook includes:
- python dependencies
- tabix
- bcftools

```
ansible-playbook playbook.yaml
```

## Parallel workload

To run a workload make sure that your own scripts and data are in place on remote nodes.
We are providing example `tasks.txt`, with one command per line.

Starting a workload on nodes:

```
cat tasks.txt | parallel --sshloginfile hosts.txt -j1 --no-run-if-empty
```

(-j == 1 job per node)

## Simulate on local computer (notebook)

Requires Vagrant, VirtualBox, and Ansible to be installed. Vagrant will setup virtual
machines that will be provisioned with our Ansible playbook.

```
vagrant up
vagrant status

# Test SSH access
vagrant ssh compute-1
```
