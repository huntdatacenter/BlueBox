![BlueBox - IAAS toolkit](https://raw.githubusercontent.com/huntdatacenter/BlueBox/master/bluebox/files/bluebox_title_ref_undraw.png | height=250)

BlueBox helps to move into distributed compute with your research workload.
It simplifies installation of dependency packages on multiple servers.
Handling data, code and results is still as easy as with single machine.

## Setup your home first (master)

Install dependencies on your home server:

```
sudo apt update && sudo apt install -y tox sshpass
```

Get this repository:
```
git clone https://github.com/huntdatacenter/bluebox.git && cd bluebox
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

- [Guide](https://github.com/huntdatacenter/BlueBox/blob/master/docs/guide.md)
- [Best practices](https://github.com/huntdatacenter/BlueBox/blob/master/docs/best_practice.md)
- [FAQ - Frequently asked questions](https://github.com/huntdatacenter/BlueBox/blob/master/docs/faq.md)

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
code follow `example.packages.yml` when defining your own config `package.yml`.
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
We are providing example in `example.tasks.txt`, with one command per line, e.g.:
```
bash example.sh J01
bash example.sh J02
bash example.sh J03
...
```

Starting a workload on nodes:
```
make run tasks=example.tasks.txt
```

Command above is wrapping distribution of tasks to hosts using parallel, which shortcuts long version:
```
parallel --ungroup --joblog task.log --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/bluebox :::: tasks.txt
```

- j: number of jobs per node
- ungroup: immediate output in terminal, do not use if need output of jobs organised in groups
- workdir: directory with scripts/code
  [GNU Parallel - manual pages](https://www.gnu.org/software/parallel/man.html)

To run all (clean, code, data, tasks, and results) commands use the shortcut:

```
make run-all
```

In our example we just let the node sleep for some time and report which nodes are assigned jobs,
when they start and when they are done.
