# Vagrant - simulate on local computer (notebook)

Requires Vagrant, VirtualBox, and Ansible to be installed. Vagrant will provide virtual
machines with ubuntu, on which you can test your setup:
```
cd bluebox
vagrant up
vagrant status
```

Test SSH access:
```
vagrant ssh iaas-node-1
```

When you have your vagrant nodes up and ready follow up with [Usage guide](https://github.com/huntdatacenter/BlueBox/blob/master/docs/usage.md).
