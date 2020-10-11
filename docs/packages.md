# Package dependencies

## APT Packages

List names of required apt packages

```
apt_packages:
  - r-base
```

##  Python PIP Packages

https://pypi.org/

Required options:
  - name: Name of the package
Optional options:
  - state: present, latest, or absent
  - version

```
python_pip_packages:
  - name: pysam
    state: present
  - name: numpy
    state: present
  - name: pandas
    state: present
  - name: memory-profiler
    state: present
```

## R Packages

https://github.com/yutannihilation/ansible-module-cran

Required options:
  - name: Name of the package
Optional options:
  - state: State in which to leave the Python package (Choices: present, absent, latest) [Default: present]
  - repo: Repository of package if not default [Default: None]

```
r_packages:
  - dplyr
```

## Conda Packages

https://github.com/UDST/ansible-conda

Required options:
  - name: Name of the package
Optional options:
  - state: State in which to leave the Python package (Choices: present, absent, latest) [Default: present]
  - channels: Extra channels to use when installing packages [Default: None]
  - extra_args: Extra arguments passed to conda [Default: None]
  - version: A specific version of a library to install [Default: None]

```
conda_packages:
  - name: bcftools
    channels: bioconda
```

No conda packages required:

```
conda_packages: []
```

# Docker Example

Example of docker installation using packages.yml definition based on
[Official docker installation guide for Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
shows how to correctly set apt keys and add official apt repository, to be able to install
essential docker packages:

```
apt_keys:
  - id: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    url: https://download.docker.com/linux/ubuntu/gpg

apt_repositories:
  - repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    filename: "docker-engine"

apt_packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
```
