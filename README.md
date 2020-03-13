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

Follow GNU parallel format. Where ubuntu is a user, and `node-X-IP` should be replace with IP addresses of nodes.
```
ubuntu@node-1-IP
ubuntu@node-2-IP
...
ubuntu@node-X-IP
```

Example hosts.txt:
```
ubuntu@192.168.150.11
ubuntu@192.168.150.12
```

### Provisioning environment on IAAS nodes (workers)

If you need to setup SSH keys run a playbook with tag `setupkeys`, which will generate a key
and try to connect to nodes and place the public key. Otherwise you should place your private
key to `files/cluster-ssh-key` for Ansible to use it.

```
ansible-playbook playbook.yaml -t setupkeys
```

Then follow with installation of remote environments and dependencies for all nodes.
Playbook includes:
- python dependencies
- tabix
- bcftools

Synchronizes scripts from `code` directory to remote servers.

```
ansible-playbook playbook.yaml
```

## Push data / pull results

When pushing data and pulling results, set variables data_path and results_path respectively
to your local path. On the server data will be available at /home/ubuntu/data,
and your scripts should save results to /home/ubuntu/results

```
ansible-playbook playbook.yaml -t push --extra-vars "data_path=./data"

ansible-playbook playbook.yaml -t pull --extra-vars "results_path=./results"
```

To remove your data or results run these command respectively:
```
ansible-playbook playbook.yaml -t cleandata
ansible-playbook playbook.yaml -t cleanresults
```

To debug content on remote servers list files:
```
ansible-playbook playbook.yaml -t listdata
ansible-playbook playbook.yaml -t listresults
```


## Parallel workload

To run a workload make sure that your own scripts and data are in place on remote nodes.
We are providing example `tasks.txt`, with one command per line, e.g.:

```
bash example.sh J01
bash example.sh J02
bash example.sh J03
...
```

Starting a workload on nodes:

```
cat tasks.txt | parallel -j1 --ungroup --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/code
```

- j: number of jobs per node
- ungroup: immediate output in terminal, do not use if need output of jobs organised in groups
- workdir: directory with scripts/code

In our example we just let the node sleep for some time and report which nodes are assigned jobs,
when they start and when they are done.

## Simulate on local computer (notebook)

Requires Vagrant, VirtualBox, and Ansible to be installed. Vagrant will setup virtual
machines that will be provisioned with our Ansible playbook.

```
vagrant up
vagrant status

# Test SSH access
vagrant ssh compute-1
```
