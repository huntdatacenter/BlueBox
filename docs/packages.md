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
