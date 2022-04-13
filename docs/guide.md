# Guide

When you have `tox` installed and repository cloned on your home node follow up
with this usage guide.

## 1. Setting up environment on IAAS nodes (workers)

When using first time or adding nodes run initial setup of IAAS nodes.
- sets up ssh keys
- common dependencies
- code dependencies

```
make setup
```

## 2. Dependencies

If you have specific dependencies (apt, pip, R, or conda packages) for your
code follow `example.packages.yml` when defining your own config `package.yml`.
If you just need to update these dependencies, on nodes that already have
been set up, run:
```
make deps
```

Read more about defining
[Package dependencies](https://github.com/huntdatacenter/BlueBox/blob/master/docs/packages.md).

## 3. Push code

Synchronise scripts from `code` directory to all IAAS servers:
```
make code
```

## 4. Push data

To simply push data from ./data directory to remote nodes run:
```
make data
```

If you need to remove the data from remote nodes:
```
make cleandata
```

## 5. Run parallel workload

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
make run tasks=example.tasks.txt joblog=task.log
```

Command above `make run` is wrapping distribution of tasks to hosts using
[Parallel](https://www.gnu.org/software/parallel/man.html#NAME), which shortcuts long version:
```
parallel --ungroup --joblog task.log --sshloginfile hosts.txt --no-run-if-empty --workdir /home/ubuntu/bluebox :::: example.tasks.txt
```

To run all (clean, code, data, tasks, and results) commands use the shortcut:
```
make run-all
```

In our example we just let the node sleep for some time and report which nodes are assigned jobs,
when they start and when they are done.

Retry failed tasks using job log (task.log):
```
make retry
```

Resume run when parallel got stopped or interrupted:
```
make resume
```

## 6. Pull results

To pull the results from remote nodes to ./results directory run:
```
make results
```

To clean the results on remote nodes after running pulling them:
```
make clean
```

---

## Using parameters


Custom tasks file:
```
make run tasks=tasks2.txt
```

Custom hosts file:
```
make run hosts=clusterA.txt
```

---

## Follow up

- [Best practices](https://github.com/huntdatacenter/BlueBox/blob/master/docs/best_practice.md)
- [FAQ - Frequently asked questions](https://github.com/huntdatacenter/BlueBox/blob/master/docs/faq.md)
- [Package dependencies](https://github.com/huntdatacenter/BlueBox/blob/master/docs/packages.md)

- [GNU Parallel - Guides](https://www.gnu.org/software/parallel/parallel_tutorial.html)
