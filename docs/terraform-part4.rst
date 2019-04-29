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

  $ git clone https://github.com/mantl/terraform.py
  $ cd terraform.py
  $ python setup.py build
  $ python setup.py install --user

This installs the Python script ``ati`` from terraform.py into
``~/.local/bin`` (e.g. your home directory). Usually, this directory
should be in your shell path. If it isn't, you can add it (for bash):

.. code-block:: console

  export PATH=$PATH:~/.local/bin

From your Terraform working directory, copy the wrapper script from
the ``terraform.py`` directory that you cloned from github, and make
it executable:

.. code-block:: console

  $ cp /path/to/terraform.py/scripts/terraform_inventory.sh .
  $ chmod a+x terraform_inventory.sh

You can then run ansible from within your Terraform working directory
to verify that dynamic inventory works:

.. code-block:: console

  $ ansible all -i terraform_inventory.sh --list-hosts
    hosts (5):
      osl-web-0
      osl-web-3
      osl-web-2
      osl-web-1
      osl-db-0

