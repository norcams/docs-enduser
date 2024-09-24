Terraform and NREC: Part IV - Pairing with Ansible
=====================================================

Last changed: 2024-09-17

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Ansible: https://www.ansible.com/
.. _EPEL: https://fedoraproject.org/wiki/EPEL
.. _Part 1: terraform-part1.html
.. _Part 2: terraform-part2.html
.. _Part 3: terraform-part3.html

This document builds on Terraform `Part 1`_, `Part 2`_ and `Part 3`_.
In `Part 3`_ we built an environment in NREC consisting of 4
frontend web servers and 1 backend database server, as well as
security groups and an SSH key pair for access. However, we didn't do
anything inside the operating systems of our instances to make them
act as web servers or database servers. Terraform_ only interacts with
the Openstack API, and doesn't do anything inside the instances. Here
is where Ansible_ comes into play. Using Ansible, we'll configure the
web servers and the database server to make a real service.

This is not an introduction to Ansible. It is assumed that the reader
has some knowledge and experience in using Ansible.

The files used in this document can be downloaded:

* :download:`terraform.yaml <downloads/tf-example4/terraform.yaml>`
* :download:`main.tf <downloads/tf-example4/main.tf>`
* :download:`secgroup.tf <downloads/tf-example4/secgroup.tf>`
* :download:`variables.tf <downloads/tf-example4/variables.tf>`
* :download:`terraform.tfvars <downloads/tf-example4/terraform.tfvars>`
* :download:`web.yaml <downloads/tf-example4/web.yaml>`
* :download:`db.yaml <downloads/tf-example4/db.yaml>`

The examples in this document have been tested and verified
with **Terraform version 1.9.5**:

.. code-block:: none

  Terraform v1.9.5
  on linux_amd64
  + provider registry.terraform.io/ansible/ansible v1.3.0
  + provider registry.terraform.io/terraform-provider-openstack/openstack v2.1.0


Installing Ansible
------------------

Ansible is available in most Linux distributions. If possible, use the
Ansible version availble from the distribution. For Fedora, and for
RHEL or equivalent with EPEL enabled, simply install using yum:

.. code-block:: console

  # yum install ansible

For Debian and Ubuntu:

.. code-block:: console

  # apt-get install ansible

When using Ansible with NREC and instances created with Terraform,
we'll often create and destroy instances multiple times. This depends
on your workflow. It may be beneficial to add the following
configuration to your ``~/.ansible.cfg`` to prevent Ansible from
halting on unknown SSH host keys:

.. code-block:: ini

  [defaults]
  host_key_checking = False


Installing Terraform Plugin for Ansible
---------------------------------------

Ansible has a Terraform collection that reads information from the
Terraform state file ``terraform.tfstate``. This needs to be installed
for this to work. Run the following command to install it::

  ansible-galaxy collection install cloud.terraform

On Linux, this installs the Terraform collection under::

  ~/.ansible/collections/ansible_collections

You can verify the Terraform collection like this:
  
.. code-block:: console

  $ ansible-galaxy collection list | grep terraform
  cloud.terraform 3.0.0


Ansible Information in Terraform State
--------------------------------------

The Terraform collection for Ansible expects certain data in the Terraform
state. We will provide this by adding some extra statements to our
Terraform ``main.tf`` file. First we need to add the Ansible plugin:

.. literalinclude:: downloads/tf-example4/main.tf
   :language: terraform
   :caption: main.tf
   :linenos:
   :lines: 1-13
   :emphasize-lines: 8-11

Running **terraform init** will then add the Ansible plugin along with
the Openstack plugin.

Next, we need to add statements that tells Ansible the relevant
details of our hosts. We define our web and database hosts, as well as
groups that contain these hosts:

.. literalinclude:: downloads/tf-example4/main.tf
   :language: terraform
   :caption: main.tf
   :linenos:
   :lines: 97-

Note the use of the ``trim()`` function for the ``ansible_host``
variable. This is needed when using the IPv6 address.


Ansible Inventory File
----------------------

The whole point is that the inventory should be generated dynamically
based on the Terraform state. But we need to tell Ansible where to
locate what it needs. For this we create an inventory file that we
call "terraform.yaml":

.. literalinclude:: downloads/tf-example4/terraform.yaml
   :language: yaml
   :caption: terraform.yaml
   :linenos:
   :emphasize-lines: 2

You will need to edit this file and set the full path to the Terraform
directory, i.e. where you ``terraform.tfstate`` is located.


Testing Ansible
---------------

.. NOTE::
   When using the ``cloud.terraform`` collection with an unsupported
   version of Ansible, we get a warning as seen in the examples
   below. It still works in our case (RHEL9).

With the ``terraform.yaml`` file in place, we can run ansible to test
and verify that it is able to reach the instances over the network:

First, we'll see that our inventory is correct:

.. code-block:: console

  $ ansible-inventory -i terraform.yaml --graph --vars
  [WARNING]: Collection cloud.terraform does not support Ansible version 2.14.14
  @all:
    |--@ungrouped:
    |--@db:
    |  |--@osl_db:
    |  |  |--osl-db-0
    |  |  |  |--{ansible_host = 2001:700:2:8201::10cf}
    |  |  |  |--{ansible_user = ubuntu}
    |  |--{ansible_user = ubuntu}
    |--@web:
    |  |--@osl_web:
    |  |  |--osl-web-0
    |  |  |  |--{ansible_host = 2001:700:2:8201::11ae}
    |  |  |  |--{ansible_user = almalinux}
    |  |  |--osl-web-1
    |  |  |  |--{ansible_host = 2001:700:2:8201::1414}
    |  |  |  |--{ansible_user = almalinux}
    |  |  |--osl-web-2
    |  |  |  |--{ansible_host = 2001:700:2:8201::1236}
    |  |  |  |--{ansible_user = almalinux}
    |  |  |--osl-web-3
    |  |  |  |--{ansible_host = 2001:700:2:8201::111d}
    |  |  |  |--{ansible_user = almalinux}
    |  |--{ansible_user = almalinux}

Next, we'll ping the instances using Ansible:
    
.. code-block:: console

  $ ansible -i terraform.yaml all -m ping
  [WARNING]: Collection cloud.terraform does not support Ansible version 2.14.14
  osl-web-2 | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3"
      },
      "changed": false,
      "ping": "pong"
  }
  osl-web-1 | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3"
      },
      "changed": false,
      "ping": "pong"
  }
  osl-web-3 | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3"
      },
      "changed": false,
      "ping": "pong"
  }
  osl-web-0 | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3"
      },
      "changed": false,
      "ping": "pong"
  }
  osl-db-0 | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3"
      },
      "changed": false,
      "ping": "pong"
  }

We can also run a command on the instances to verify that SSH
connection is working:

.. code-block:: console

  $ ansible -i terraform.yaml all -m shell -a 'uname -sr'
  [WARNING]: Collection cloud.terraform does not support Ansible version 2.14.14
  osl-db-0 | CHANGED | rc=0 >>
  Linux 6.8.0-41-generic
  osl-web-0 | CHANGED | rc=0 >>
  Linux 5.14.0-427.31.1.el9_4.x86_64
  osl-web-2 | CHANGED | rc=0 >>
  Linux 5.14.0-427.31.1.el9_4.x86_64
  osl-web-1 | CHANGED | rc=0 >>
  Linux 5.14.0-427.31.1.el9_4.x86_64
  osl-web-3 | CHANGED | rc=0 >>
  Linux 5.14.0-427.31.1.el9_4.x86_64

We have verified that Ansible and dynamic inventory from Terraform
state works, and are ready to proceed.


Using Ansible
-------------

.. IMPORTANT::

   This section includes simple playbooks to show how Ansible can be
   used for configuring the OS and services. In order to make this
   into a real service for production use, a lot more work needs to be
   done.

I order to configure the web and database servers, we have created two
playbooks. They are named ``web.yaml`` and ``db.yaml``,
respectively. We'll take a look at ``web.yaml`` first:

.. literalinclude:: downloads/tf-example4/web.yaml
   :language: yaml
   :caption: web.yaml
   :linenos:

In this playbook, we do the following:

* Install the Apache web server, PHP and the PHP MySQL bindings

* Make sure that SELinux allows Apache to connect to the
  database

* Make sure that the web service is enabled and running.

Next, lets take a look at ``db.yaml`` which we use to configure the
database server:

.. literalinclude:: downloads/tf-example4/db.yaml
   :language: yaml
   :caption: db.yaml
   :linenos:

In this playbook, we do the following:

* Create a filesystem on our volume, available as the ``/dev/sdb``
  device, and mount it as ``/var/lib/mysql``

* Install MariaDB (i.e. MySQL)

* Set the MariaDB bind address, i.e. the IP address that we want the
  database server to listen to. We use the internal, private IPv4
  address for this. When using the IPv6 network in NREC, instances
  also get a private IPv4 address. We can use this address for
  communication between instances, which in our case will be
  communication between the web servers and the database.

* Make sure that the database service is enabled and running.

* Install the MySQL bindings for Python. This is needed if we want to
  use Ansible to communicate with the database server, e.g. for
  creating databases.

The ``db.yaml`` also includes a handler for restarting MariaDB if we
have done configuration changes which require a restart to take
effect.

The Ansible playbooks above would be run like this, from the Terraform
workspace directory:

.. code-block:: console

  $ ansible-playbook -i terraform.yaml db.yaml
  $ ansible-playbook -i terraform.yaml web.yaml

--------------------------------------------------------------------

Complete example
----------------

A complete listing of the example files used in this document is
provided below.

.. literalinclude:: downloads/tf-example4/terraform.yaml
   :language: yaml
   :caption: terraform.yaml
   :name: part4-ansible-inventory
   :linenos:

.. literalinclude:: downloads/tf-example4/main.tf
   :language: terraform
   :caption: main.tf
   :name: part4-main-tf
   :linenos:

.. literalinclude:: downloads/tf-example4/secgroup.tf
   :language: terraform
   :caption: secgroup.tf
   :name: part4-secgroup-tf
   :linenos:

.. literalinclude:: downloads/tf-example4/variables.tf
   :language: terraform
   :caption: variables.tf
   :name: part4-variables-tf
   :linenos:

.. literalinclude:: downloads/tf-example4/terraform.tfvars
   :caption: terraform.tfvars
   :name: part4-terraform-tfvars
   :linenos:

.. literalinclude:: downloads/tf-example4/web.yaml
   :language: yaml
   :caption: web.yaml
   :name: part4-web.yaml
   :linenos:

.. literalinclude:: downloads/tf-example4/db.yaml
   :language: yaml
   :caption: db.yaml
   :name: part4-db.yaml
   :linenos:
