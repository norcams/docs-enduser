.. |date| date::

Terraform and NREC: Part I - Basics
======================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Part 2: terraform-part2.html

This document describes how to create and manage instances (virtual
machines) using Terraform_. This is an introduction to Terraform and
shows how to use Terraform in its simplest and most basic form.

The example file can be downloaded here: :download:`basic.tf
<downloads/tf-example1/basic.tf>`.


Prerequisites
-------------

.. _OpenStack CLI tools: api.html

You need to download and install Terraform_ (example):

.. code-block:: console

  $ unzip ~/Downloads/terraform_0.12.17_linux_amd64.zip
  $ ./terraform --version
  Terraform v0.12.17

Install the ``terraform`` binary into ``~/.local/bin`` (e.g. your home
directory):

.. code-block:: console

  $ mv ./terraform ~/.local/bin/

Usually, this directory should be in your shell path. If
it isn't, you can add it (for bash):

.. code-block:: console

  $ export PATH=$PATH:~/.local/bin

You also need to have the `OpenStack CLI tools`_ installed.


Basic Terraform usage
---------------------

Here is a Terraform file that works with NREC, in its simplest
possible form:

.. literalinclude:: downloads/tf-example1/basic.tf
   :caption: basic.tf (minimal)
   :linenos:
   :lines: 1-7,11-

As an absolute minimum, you need to specify the name, image, flavor
and network of the instance that you want Terraform to
create.

.. WARNING::
   We are using ``image_name`` here. This is usually not a good idea,
   unless for testing purposes. The "GOLD" images provided in NREC
   are renewed (e.g. replaced) each month, and Terraform uses the
   image ID in its state. If using Terraform as a oneshot utility to
   spin up instances, this isn't a problem. But if you rely on
   Terraform to maintain your virtual infrastructure over time,
   switching to ``image_id`` is encouraged. An example using
   ``image_id`` is provided in `Part 2`_.

The instance isn't very usable unless you also provide an SSH key pair
and a security group that allows access via SSH to the instance. We'll
add these, but first we'll use the CLI to list which are available:

.. code-block:: console

  $ openstack keypair list
  +-------+-------------------------------------------------+
  | Name  | Fingerprint                                     |
  +-------+-------------------------------------------------+
  | mykey | e2:2e:26:7f:5d:98:9e:8f:5e:fd:c7:d5:d0:6b:44:e7 |
  +-------+-------------------------------------------------+
  
  $ openstack security group list -c ID -c Name
  +--------------------------------------+--------------+
  | ID                                   | Name         |
  +--------------------------------------+--------------+
  | 14f30f2b-7198-4b60-943d-cd1dc67b2ac8 | RDP          |
  | 57f8deaa-5d74-4fb2-941f-f3324806f1f5 | SSH and ICMP |
  | f6c0499c-0a3c-4756-8527-9cb58e0501b1 | default      |
  +--------------------------------------+--------------+

In this example, we already have a key pair named "mykey", and we have
two security groups named "SSH and ICMP" and "RDP" in addition to the
default security group. If you don't have a key pair you will need to
add that, and the same with security groups.

.. NOTE::
   The SSH key pair is one of the very few elements that are tied to
   the user and not the project. Since we use technically different
   users for the dashboard and API, any keys that are added in the
   dashboard are not available via API, and vice versa.

Having established which key pairs and security groups we wish to use,
we can add those to our Terraform file:

.. literalinclude:: downloads/tf-example1/basic.tf
   :caption: basic.tf
   :name: basic-tf
   :linenos:
   :emphasize-lines: 8-9

We now have a Terraform execution file that is ready to be used. If
you decide to use this file, you'll probably want to change at least
the two emphasized lines.


Running Terraform
-----------------

While it is possible to enter the project name, credentials such as
user ID and password etc. in the Terraform file, this is
discouraged. Terraform will use the shell environment variables
defined in your API credentials file. Before continuing, source this
file:

.. code-block:: console

  $ source ~/keystone_rc.sh

Terraform manages its own state in the directory in which it is
run. Therefore, it is always a good idea to maintain the Terraform
files and run Terraform within a specified directory. We'll start with
creating a directory which we'll call **tf-project**:

.. code-block:: console

  $ mkdir ~/tf-project

We then create the initial Terraform :ref:`basic-tf` file as outlined
in the previous section. The name "basic.tf" is arbitrary, Terraform
will search for any files with a ".tf" ending. This file can be
:download:`downloaded here <downloads/tf-example1/basic.tf>`. Our Terraform
directory should now contain only this file:

.. code-block:: console

  $ cd ~/tf-project
  $ ls -a
  .  ..  basic.tf

Next we need to initialise Terraform:

.. code-block:: console

  $ terraform init
  
  Initializing the backend...
  
  Initializing provider plugins...
  - Checking for available provider plugins...
  - Downloading plugin for provider "openstack" (terraform-providers/openstack) 1.24.0...
  
  The following providers do not have any version constraints in configuration,
  so the latest version was installed.
  
  To prevent automatic upgrades to new major versions that may contain breaking
  changes, it is recommended to add version = "..." constraints to the
  corresponding provider blocks in configuration, with the constraint strings
  suggested below.
  
  * provider.openstack: version = "~> 1.24"
  
  Terraform has been successfully initialized!
  
  You may now begin working with Terraform. Try running "terraform plan" to see
  any changes that are required for your infrastructure. All Terraform commands
  should now work.
  
  If you ever set or change modules or backend configuration for Terraform,
  rerun this command to reinitialize your working directory. If you forget, other
  commands will detect it and remind you to do so if necessary.

We can then run ``terraform plan`` to see what actions Terraform will
perform in a subsequent run:

.. code-block:: console

  $ terraform plan
  Refreshing Terraform state in-memory prior to plan...
  The refreshed state will be used to calculate this plan, but will not be
  persisted to local or remote state storage.
  
  
  ------------------------------------------------------------------------
  
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.instance will be created
    + resource "openstack_compute_instance_v2" "instance" {
        + access_ip_v4        = (known after apply)
        + access_ip_v6        = (known after apply)
        + all_metadata        = (known after apply)
        + all_tags            = (known after apply)
        + availability_zone   = (known after apply)
        + flavor_id           = (known after apply)
        + flavor_name         = "m1.small"
        + force_delete        = false
        + id                  = (known after apply)
        + image_id            = (known after apply)
        + image_name          = "GOLD CentOS 7"
        + key_pair            = "mykey"
        + name                = "test"
        + power_state         = "active"
        + region              = (known after apply)
        + security_groups     = [
            + "SSH and ICMP",
            + "default",
          ]
        + stop_before_destroy = false
  
        + network {
            + access_network = false
            + fixed_ip_v4    = (known after apply)
            + fixed_ip_v6    = (known after apply)
            + floating_ip    = (known after apply)
            + mac            = (known after apply)
            + name           = "IPv6"
            + port           = (known after apply)
            + uuid           = (known after apply)
          }
      }
  
  Plan: 1 to add, 0 to change, 0 to destroy.
  
  ------------------------------------------------------------------------
  
  Note: You didn't specify an "-out" parameter to save this plan, so Terraform
  can't guarantee that exactly these actions will be performed if
  "terraform apply" is subsequently run.

The next step will be to actually run Terraform:

.. code-block:: console

  $ terraform apply
  
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.instance will be created
    + resource "openstack_compute_instance_v2" "instance" {
        + access_ip_v4        = (known after apply)
        + access_ip_v6        = (known after apply)
        + all_metadata        = (known after apply)
        + all_tags            = (known after apply)
        + availability_zone   = (known after apply)
        + flavor_id           = (known after apply)
        + flavor_name         = "m1.small"
        + force_delete        = false
        + id                  = (known after apply)
        + image_id            = (known after apply)
        + image_name          = "GOLD CentOS 7"
        + key_pair            = "mykey"
        + name                = "test"
        + power_state         = "active"
        + region              = (known after apply)
        + security_groups     = [
            + "SSH and ICMP",
            + "default",
          ]
        + stop_before_destroy = false
  
        + network {
            + access_network = false
            + fixed_ip_v4    = (known after apply)
            + fixed_ip_v6    = (known after apply)
            + floating_ip    = (known after apply)
            + mac            = (known after apply)
            + name           = "IPv6"
            + port           = (known after apply)
            + uuid           = (known after apply)
          }
      }
  
  Plan: 1 to add, 0 to change, 0 to destroy.
  
  Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.
  
    Enter a value: yes
  
  openstack_compute_instance_v2.instance: Creating...
  openstack_compute_instance_v2.instance: Still creating... [10s elapsed]
  openstack_compute_instance_v2.instance: Still creating... [20s elapsed]
  openstack_compute_instance_v2.instance: Creation complete after 26s [id=fa854163-2440-43b2-9971-437ed490e386]
  
  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

And we can use the Openstack CLI to verify that the instance has been
created:

.. code-block:: console

  $ openstack server list
  +--------------------------------------+------+--------+---------------------------------------+---------------+----------+
  | ID                                   | Name | Status | Networks                              | Image         | Flavor   |
  +--------------------------------------+------+--------+---------------------------------------+---------------+----------+
  | e1df5188-fa7d-4752-8819-9a9b7e781141 | test | ACTIVE | IPv6=2001:700:2:8201::1029, 10.2.0.57 | GOLD CentOS 7 | m1.small |
  +--------------------------------------+------+--------+---------------------------------------+---------------+----------+

The host should be pingable and accessible via SSH. Let's test that:

.. code-block:: console

  $ ping6 -c3 2001:700:2:8201::1029
  PING 2001:700:2:8201::1029(2001:700:2:8201::1029) 56 data bytes
  64 bytes from 2001:700:2:8201::1029: icmp_seq=1 ttl=56 time=0.652 ms
  64 bytes from 2001:700:2:8201::1029: icmp_seq=2 ttl=56 time=0.510 ms
  64 bytes from 2001:700:2:8201::1029: icmp_seq=3 ttl=56 time=0.486 ms
  
  --- 2001:700:2:8201::1029 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2000ms
  rtt min/avg/max/mdev = 0.486/0.549/0.652/0.075 ms
  
  $ ssh centos@2001:700:2:8201::1029
  The authenticity of host '2001:700:2:8201::1029 (2001:700:2:8201::1029)' can't be established.
  ECDSA key fingerprint is SHA256:H2gmupThy7A0qFTQWTFl/1VmT75G7vuITSOCMHhUzLs.
  ECDSA key fingerprint is MD5:68:a7:94:9b:32:4e:98:8d:8e:26:f8:8c:03:7e:1b:d5.
  Are you sure you want to continue connecting (yes/no)? yes
  Warning: Permanently added '2001:700:2:8201::1029' (ECDSA) to the list of known hosts.
  Last login: Wed Mar 27 19:05:40 2019 from 158.37.63.253

As stated earlier, Terraform maintains its state in the local
directory, so we can use Terraform to destroy the resources it has
previously created:

.. code-block:: console

  $ terraform destroy
  openstack_compute_instance_v2.instance: Refreshing state... [id=fa854163-2440-43b2-9971-437ed490e386]
  
  An execution plan has been generated and is shown below.
  Resource actions are indicated with the following symbols:
    - destroy
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.instance will be destroyed
    - resource "openstack_compute_instance_v2" "instance" {
        - access_ip_v4        = "10.1.0.204" -> null
        - access_ip_v6        = "[2001:700:2:8301::112d]" -> null
        - all_metadata        = {} -> null
        - all_tags            = [] -> null
        - availability_zone   = "bgo-default-1" -> null
        - flavor_id           = "b7d00d03-3bbc-44ab-88b4-0b6a20f9a1a8" -> null
        - flavor_name         = "m1.small" -> null
        - force_delete        = false -> null
        - id                  = "fa854163-2440-43b2-9971-437ed490e386" -> null
        - image_id            = "1a38633c-5fd1-4c01-b447-b1128ed3bb3f" -> null
        - image_name          = "GOLD CentOS 7" -> null
        - key_pair            = "mykey" -> null
        - name                = "test" -> null
        - power_state         = "active" -> null
        - region              = "bgo" -> null
        - security_groups     = [
            - "SSH and ICMP",
            - "default",
          ] -> null
        - stop_before_destroy = false -> null
        - tags                = [] -> null
  
        - network {
            - access_network = false -> null
            - fixed_ip_v4    = "10.1.0.204" -> null
            - fixed_ip_v6    = "[2001:700:2:8301::112d]" -> null
            - mac            = "fa:16:3e:9d:58:10" -> null
            - name           = "IPv6" -> null
            - uuid           = "339cb0e4-ca57-478f-ac46-200185b017fc" -> null
          }
      }
  
  Plan: 0 to add, 0 to change, 1 to destroy.
  
  Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.
  
    Enter a value: yes
  
  openstack_compute_instance_v2.instance: Destroying... [id=fa854163-2440-43b2-9971-437ed490e386]
  openstack_compute_instance_v2.instance: Still destroying... [id=fa854163-2440-43b2-9971-437ed490e386, 10s elapsed]
  openstack_compute_instance_v2.instance: Destruction complete after 11s
  
  Destroy complete! Resources: 1 destroyed.

And the instance is gone.

