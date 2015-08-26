Features:

  * Create only to run on Centos 7.1,
  * Install Slurm 15.0.8 (Last release),
  * Install Slurm controler, nodes,
  * Using Mysql accounting on Slurm Controler.

Ansible
=======

Ansible is a radically simple IT automation system.  It handles configuration-management, application deployment, cloud provisioning, ad-hoc task-execution, and multinode orchestration - including trivializing things like zero downtime rolling updates with load balancers.

Read the documentation and more at http://ansible.com/

If you want to download a tarball of a release, go to [releases.ansible.com](http://releases.ansible.com/ansible), though most users use `yum` (using the EPEL instructions linked above), `apt` (using the PPA instructions linked above), or `pip install ansible`.

# Playbooks [Read more here](http://docs.ansible.com/ansible/playbooks.html)

Playbooks are Ansible’s configuration, deployment, and orchestration language. They can describe a policy you want your remote systems to enforce, or a set of steps in a general IT process.


Usage
==============
### First you need set your host on hosts file

 * Dont forget set the Head controler and nodes

```
[HC]
headcontroler.example.com

[nodes]
node[1:3].example.com
```

### Create a munge.key
  * On your workstation, after Ansible will copy to the all nodes

```
dd if=/dev/urandom bs=1 count=1024 > /tmp/munge.key
```

### After run on HC node

```
$ ansible-playbook -v -i hosts ./run.yml -u root -e "host=HC" -K -k
```

### After that run on nodes

```
$ ansible-playbook -v -i hosts ./run.yml -u root -e "host=nodes" -K -k
```

Deploy configuration
==============
First you need set your Slurm.conf.j2 and slurmdbd.conf.j2 on /roles/hc/templates (can use the templates available), and the config to the nodes on /roles/nodes/templates/Slurm.conf.j2.

```
$ ansible-playbook -v -i hosts ./deployconfigs.yml -u root -e "host=all" -K -k
```

	* The deployconfigs.yml will set on all nodes the specific information (CPUs, RAM, HOSTNAME)

Check status of slurm
==============

```
$ ansible -i hosts all -u root -m shell -a "ps -faux | grep slurm"
```


# TODO:
 * Fix all config to run on Slurm 15.0
 * Create a Playbook to run Slurm testsuite
