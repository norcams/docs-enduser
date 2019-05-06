.. |date| date::

Terraform and UH-IaaS: Part IV - Pairing with Ansible
=====================================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Ansible: https://www.ansible.com/
.. _EPEL: https://fedoraproject.org/wiki/EPEL
.. _Part 1: terraform-part1.html
.. _Part 2: terraform-part2.html
.. _Part 3: terraform-part3.html

.. IMPORTANT::
   This document is under construction!

This document builds on Terraform `Part 1`_, `Part 2`_ and `Part 3`_.
In `Part 3`_ we built an environment in UH-IaaS consisting of 4
frontend web servers and 1 backend database server, as well as
security groups and an SSH key pair for access. However, we didn't do
anything inside the operating systems of our instances to make them
act as web servers or database servers. Terraform_ only interacts with
the Openstack API, and doesn't do anything inside the instances. Here
is where Ansible_ comes into play. Using Ansible, we'll configure the
web servers and the database server to make a real service.

This is not an introduction to Ansible. It is assumed that the reader
has some knowledge and experience in using Ansible.


Installing Ansible
------------------

Ansible is available in most Linux distributions. If possible, use the
Ansible version availble from the distribution. For Fedora, and for
RHEL or CentOS with EPEL enabled, simply install using yum:

.. code-block:: console

  # yum install ansible

For Debian and Ubuntu:

.. code-block:: console

  # apt-get install ansible


Ansible inventory from Terraform state
--------------------------------------

Terraform maintains a state in the working directory, and is also able
to update its local state against the real resources in UH-IaaS. The
local state is stored in ``terraform.tfstate``, and we're using a
Python script that reads this file and produces an Ansible inventory
dynamically.

To use the Python script we need to install and set it up:

.. code-block:: console

  $ curl https://raw.githubusercontent.com/trondham/kubespray/terraform-py-ipv6-openstack/contrib/terraform/terraform.py -o ~/.local/bin/terraform.py
  $ chmod a+x ~/.local/bin/terraform.py 

.. NOTE::
   This is from a fork of the kubespray repository. A pull request has
   been created in order to get our changes into the upstream
   repository.

This installs the Python script ``terraform.py`` into ``~/.local/bin``
(e.g. your home directory). Usually, this directory should be in your
shell path. If it isn't, you can add it (for bash):

.. code-block:: console

  export PATH=$PATH:~/.local/bin

In your Terraform working directory, create a directory called
"inventory", and create a symbolic link "hosts" that points to the
``terraform.py`` script:

.. code-block:: console

  $ mkdir inventory
  $ ln -s ~/.local/bin/terraform.py inventory/hosts

You can then run ansible from within your Terraform working directory
to verify that dynamic inventory works:

.. code-block:: console

  $ ansible all -i inventory --list-hosts
    hosts (5):
      osl-db-0
      osl-web-0
      osl-web-3
      osl-web-2
      osl-web-1

This only lists the hosts and verifies that the dynamic inventory
works. Having Ansible actually connect to the hosts requires
additional configuration as described in the next section.


Configuring Ansible connectivity
--------------------------------

In order for Ansible to function correctly we need to tell Ansible
additional information about the instances. First, we add a map in
``variables.tf`` to address the SSH user. Ansible needs to know which
SSH user to connect as:

.. literalinclude:: downloads/tf-example4/variables.tf
   :caption: variables.tf
   :linenos:
   :lines: 44-51

Next, we need to use those variables and add a metadata directive in
the compute instance resource. The script **terraform.py** will use
this metadata to correctly create inventory for Ansible. For the web
servers (CentOS 7):

.. literalinclude:: downloads/tf-example4/main.tf
   :caption: main.tf
   :linenos:
   :lines: 29-32

And for the database server (Ubuntu 18.04 LTS):

.. literalinclude:: downloads/tf-example4/main.tf
   :caption: main.tf
   :linenos:
   :lines: 59-63

We have added this metadata:

* ``ssh_user``: Using the map variable created in variables.tf (see
  above).

* ``prefer_ipv6``: This tells **terraform.py** that we want Ansible to
  use the IPv6 address of the instance. This is needed in our case as
  we're using the IPv6 network type in UH-IaaS. When using the
  dualStack network, this is usually not needed.

* ``python_bin``: This is only used on the database server
  (Ubuntu). Ansible needs a working Python binary to function, and in
  Ubuntu's case there isn't a ``/usr/bin/python`` and Ansible needs to
  be explicitly told which binary to use on the instance.

With these in place, having applied the configuration with ``terraform
apply``, we can run ansible and verify that it is able to reach the
instances over the network:

.. code-block:: console

  $ ansible all -i inventory -m ping
  osl-web-2 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
  }
  osl-web-1 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
  }
  osl-web-3 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
  }
  osl-web-0 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
  }
  osl-db-0 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
  }

We can also run a command on the instances to verify that SSH
connection is working:

.. code-block:: console

  $ ansible all -i inventory -m shell -a 'uname -sr'
  osl-web-3 | CHANGED | rc=0 >>
  Linux 3.10.0-957.10.1.el7.x86_64
  
  osl-web-0 | CHANGED | rc=0 >>
  Linux 3.10.0-957.10.1.el7.x86_64
  
  osl-web-1 | CHANGED | rc=0 >>
  Linux 3.10.0-957.10.1.el7.x86_64
  
  osl-web-2 | CHANGED | rc=0 >>
  Linux 3.10.0-957.10.1.el7.x86_64
  
  osl-db-0 | CHANGED | rc=0 >>
  Linux 4.15.0-47-generic

We have verified that Ansible and dynamic inventory from Terraform
state works, and are ready to proceed.

