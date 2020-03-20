# Scibox - IAAS toolkit

Example research setup for running workload over multiple IAAS nodes.
Distributing data, dependencies and code using ansible.

## Setup on home (master)

Install dependencies on your home server:

```
which tox || sudo apt install python3-tox
```

Get this repository:
```
git clone https://github.com/huntdatacenter/scibox.git && cd scibox
```

Use `code`, `data`, and `results` folders in the repository for synchronisation (read below).
We provide basic examples, but otherwise are these folders excluded from git repository,
so you can keep using them and get updates.

Before using your IAAS nodes create the node list `vim hosts.txt`. Follow example hosts:

```
ubuntu@192.168.150.11
ubuntu@192.168.150.12
ubuntu@192.168.150.13
```

## Usage

Run `make` to get help on commands:

```
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

### Setting up environment on IAAS nodes (workers)

When using first time or adding nodes run initial setup of IAAS nodes.
- sets up ssh keys
- common dependencies
- code dependencies

```
make setup
```

### Dependencies

If you have specific dependencies (apt, pip, R, or conda packages) for your
code follow `default.packages.yml` when defining your own config `package.yml`.
If you just need to update these dependencies, on nodes that already have
been set up, run:
```
make deps
```

### Push code

Synchronise scripts from `code` directory to all IAAS servers:
```
make code
```

### Push data

To simply push data from ./data directory to remote nodes run:
```
make data
```

If you need to remove the data from remote nodes:
```
make cleandata
```

### Pull results

To pull the results from remote nodes to ./results directory run:
```
make results
```

To clean the results on remote nodes after running pulling them:
```
make clean
```


## Run parallel workload

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

Command above is wrapping distribution of tasks to hosts using parallel, which shortcuts long version:
```
cat tasks.txt | parallel --ungroup --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/scibox
```

- j: number of jobs per node
- ungroup: immediate output in terminal, do not use if need output of jobs organised in groups
- workdir: directory with scripts/code
  [GNU Parallel - manual pages](https://www.gnu.org/software/parallel/man.html)

In our example we just let the node sleep for some time and report which nodes are assigned jobs,
when they start and when they are done.

## Simulate on local computer (notebook)

Requires Vagrant, VirtualBox, and Ansible to be installed. Vagrant will provide virtual
machines with ubuntu, on which you can test your setup:
```
cd scibox
vagrant up
vagrant status
```

Test SSH access:
```
vagrant ssh iaas-node-1
```
