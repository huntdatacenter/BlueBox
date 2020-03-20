# IAAS-scibox-example

Example research setup for running workload over multiple IAAS nodes

```
scibox:~/scibox$ make
lint                 Run linter
setup                Setup nodes for use
data                 Push data
deps                 Install dependencies
code                 Push code
results              Pull results
clean                Clean results remote
list                 List results remote
cleandata            Clean data remote
listdata             List data remote
run                  Run tasks.txt
help                 Show this help
```

## Setup on home (master)

Install dependencies on your home server:

```
sudo apt install python3-tox
```

Get this repository:
```
git clone https://github.com/huntdatacenter/IAAS-scibox-example.git
cd IAAS-scibox-example
```

## List of nodes - inventory

Before using your IAAS nodes create the node list in `hosts.txt`.
```
vim hosts.txt
```

Follow example hosts:
```
ubuntu@192.168.150.11
ubuntu@192.168.150.12
```

### Provisioning environment on IAAS nodes (workers)

When using first time or adding nodes run initial setup of IAAS nodes.
- sets up ssh keys
- common dependencies
- code dependencies

```
make setup
```

If you have specific dependencies for your code follow `default.packages.yml`
when defining your own config `package.yml`. If you just need to update
these dependencies run:

```
make deps
```

Synchronize scripts from `code` directory to IAAS servers.

```
make code
```

## Push data /

To simply push data from ./data directory to remote nodes run:

```
make data
```

If you need to remove the data from remote nodes:

```
make cleandata
```

## Pull results

To pull the results from remote nodes to ./results directory run:

```
make results
```

To clean the results on remote nodes after running pulling them:

```
make clean
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
make run
```

Which is wrapping distribution of tasks to hosts:

```
cat tasks.txt | parallel -j1 --ungroup --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/scibox
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
