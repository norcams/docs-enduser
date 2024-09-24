Terraform and NREC: Part I - Basics
======================================

Last changed: 2024-09-17

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Part 2: terraform-part2.html
.. _Working with Security Groups: security-groups.html

This document describes how to create and manage instances (virtual
machines) using Terraform_. This is an introduction to Terraform and
shows how to use Terraform in its simplest and most basic form.

The example file can be downloaded here: :download:`basic.tf
<downloads/tf-example1/basic.tf>`.

The examples in this document have been tested and verified
with **Terraform version 1.9.5**::

  Terraform v1.9.5
  on linux_amd64
  + provider registry.terraform.io/terraform-provider-openstack/openstack v2.1.0

Prerequisites
-------------

.. _OpenStack CLI tools: api.html
.. _Install Terraform: https://developer.hashicorp.com/terraform/install?product_intent=terraform

You need to download and install Terraform_. Instructions on how to
install Terraform is provided here:

* `Install Terraform`_

Generally we recommend installing via the package manager if
possible. This option should be available for Linux and MacOS, and
ensures that updates are easily available.

You also need to have the `OpenStack CLI tools`_ installed.


Basic Terraform usage
---------------------

Here is a Terraform file that works with NREC, in its simplest
possible form:

.. literalinclude:: downloads/tf-example1/basic.tf
   :language: terraform
   :caption: basic.tf (minimal)
   :linenos:
   :lines: 1-21,25-

As an absolute minimum, you need to specify the name, image, flavor
and network of the instance that you want Terraform to
create.

.. WARNING::
   We are using ``image_name`` here. This is usually not a good idea,
   unless we also instruct Terraform to ignore changes to the image
   name and ID. The "GOLD" images provided in NREC are renewed
   (e.g. replaced) each month, and Terraform uses the image ID in its
   state. If using Terraform as a oneshot utility to spin up
   instances, this isn't a problem. But if you rely on Terraform to
   maintain your virtual infrastructure over time, you need to make
   Terraform ignore these changes. More info in `Part 2`_.

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
  +--------------------------------------+--------------------------------+
  | ID                                   | Name                           |
  +--------------------------------------+--------------------------------+
  | ee961c8a-aa31-42af-871f-dda89d964f55 | SSH and ICMP from login.uio.no |
  | f6c0499c-0a3c-4756-8527-9cb58e0501b1 | default                        |
  +--------------------------------------+--------------------------------+

In this example, we already have a key pair named "mykey", and we have
one security groups named "SSH and ICMP from login.uio.no" in
addition to the default security group. If you don't have a key pair
you will need to add that, and the same with security groups. See
`Working with Security Groups`_ for info on security groups.

.. NOTE::
   The SSH key pair is one of the very few elements that are tied to
   the user and not the project. Since we use technically different
   users for the dashboard and API, any keys that are added in the
   dashboard are not available via API, and vice versa.

Having established which key pairs and security groups we wish to use,
we can add those to our Terraform file:

.. literalinclude:: downloads/tf-example1/basic.tf
   :language: terraform
   :caption: basic.tf
   :name: basic-tf
   :linenos:
   :emphasize-lines: 22-23

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
  - Finding latest version of terraform-provider-openstack/openstack...
  - Installing terraform-provider-openstack/openstack v2.1.0...
  - Installed terraform-provider-openstack/openstack v2.1.0 (self-signed, key ID 4F80527A391BEFD2)
  Partner and community providers are signed by their developers.
  If you'd like to know more about provider signing, you can read about it here:
  https://www.terraform.io/docs/cli/plugins/signing.html
  Terraform has created a lock file .terraform.lock.hcl to record the provider
  selections it made above. Include this file in your version control repository
  so that Terraform can guarantee to make the same selections by default when
  you run "terraform init" in the future.
  
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
  
  Terraform used the selected providers to generate the following
  execution plan. Resource actions are indicated with the following
  symbols:
    + create
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.test-server will be created
    + resource "openstack_compute_instance_v2" "test-server" {
        + access_ip_v4        = (known after apply)
        + access_ip_v6        = (known after apply)
        + all_metadata        = (known after apply)
        + all_tags            = (known after apply)
        + availability_zone   = (known after apply)
        + created             = (known after apply)
        + flavor_id           = (known after apply)
        + flavor_name         = "m1.small"
        + force_delete        = false
        + id                  = (known after apply)
        + image_id            = (known after apply)
        + image_name          = "GOLD Alma Linux 9"
        + key_pair            = "mykey"
        + name                = "test-server"
        + power_state         = "active"
        + region              = (known after apply)
        + security_groups     = [
            + "ssh_icmp_login.uio.no",
            + "default",
          ]
        + stop_before_destroy = false
        + updated             = (known after apply)
  
        + network {
            + access_network = false
            + fixed_ip_v4    = (known after apply)
            + fixed_ip_v6    = (known after apply)
            + mac            = (known after apply)
            + name           = "IPv6"
            + port           = (known after apply)
            + uuid           = (known after apply)
          }
      }
  
  Plan: 1 to add, 0 to change, 0 to destroy.
  
  ─────────────────────────────────────────────────────────────────────────────
  
  Note: You didn't use the -out option to save this plan, so Terraform
  can't guarantee to take exactly these actions if you run "terraform
  apply" now.

The next step will be to actually run Terraform:

.. code-block:: console

  $ terraform apply
  
  Terraform used the selected providers to generate the following execution
  plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.test-server will be created
    + resource "openstack_compute_instance_v2" "test-server" {
        + access_ip_v4        = (known after apply)
        + access_ip_v6        = (known after apply)
        + all_metadata        = (known after apply)
        + all_tags            = (known after apply)
        + availability_zone   = (known after apply)
        + created             = (known after apply)
        + flavor_id           = (known after apply)
        + flavor_name         = "m1.small"
        + force_delete        = false
        + id                  = (known after apply)
        + image_id            = (known after apply)
        + image_name          = "GOLD Alma Linux 9"
        + key_pair            = "mykey"
        + name                = "test-server"
        + power_state         = "active"
        + region              = (known after apply)
        + security_groups     = [
            + "default",
            + "ssh_icmp_login.uio.no",
          ]
        + stop_before_destroy = false
        + updated             = (known after apply)
  
        + network {
            + access_network = false
            + fixed_ip_v4    = (known after apply)
            + fixed_ip_v6    = (known after apply)
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
  
  openstack_compute_instance_v2.test-server: Creating...
  openstack_compute_instance_v2.test-server: Still creating... [10s elapsed]
  openstack_compute_instance_v2.test-server: Creation complete after 16s [id=4012ffb2-e63c-4e42-992d-759062755877]
  
  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

And we can use the Openstack CLI to verify that the instance has been
created:

.. code-block:: console

  $ openstack server list
  +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
  | ID                                   | Name        | Status | Networks                               | Image             | Flavor   |
  +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
  | 4012ffb2-e63c-4e42-992d-759062755877 | test-server | ACTIVE | IPv6=10.2.0.117, 2001:700:2:8201::10de | GOLD Alma Linux 9 | m1.small |
  +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+

The host should be pingable and accessible via SSH from
login.uio.no. Let's test that:

.. code-block:: console

  $ ping -c3 2001:700:2:8201::10de
  PING 2001:700:2:8201::10de(2001:700:2:8201::10de) 56 data bytes
  64 bytes from 2001:700:2:8201::10de: icmp_seq=1 ttl=55 time=0.572 ms
  64 bytes from 2001:700:2:8201::10de: icmp_seq=2 ttl=55 time=0.414 ms
  64 bytes from 2001:700:2:8201::10de: icmp_seq=3 ttl=55 time=0.455 ms
  
  --- 2001:700:2:8201::10de ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2051ms
  rtt min/avg/max/mdev = 0.414/0.480/0.572/0.066 ms
  
  $ ssh almalinux@2001:700:2:8201::10de
  The authenticity of host '2001:700:2:8201::10de (2001:700:2:8201::10de)' can't be established.
  ED25519 key fingerprint is SHA256:aS7m78djSvYgqElbwn4bWDFSCWs+o3vm1DLnmGGDN3Y.
  This key is not known by any other names
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  Warning: Permanently added '2001:700:2:8201::10de' (ED25519) to the list of known hosts.
  Last login: Mon Aug 26 01:32:52 2024 from 158.39.75.247
  [almalinux@test-server ~]$ 

As stated earlier, Terraform maintains its state in the local
directory, so we can use Terraform to destroy the resources it has
previously created:

.. code-block:: console

  $ terraform destroy
  openstack_compute_instance_v2.test-server: Refreshing state... [id=4012ffb2-e63c-4e42-992d-759062755877]
  
  Terraform used the selected providers to generate the following execution
  plan. Resource actions are indicated with the following symbols:
    - destroy
  
  Terraform will perform the following actions:
  
    # openstack_compute_instance_v2.test-server will be destroyed
    - resource "openstack_compute_instance_v2" "test-server" {
        - access_ip_v4        = "10.2.0.117" -> null
        - access_ip_v6        = "[2001:700:2:8201::10de]" -> null
        - all_metadata        = {} -> null
        - all_tags            = [] -> null
        - availability_zone   = "osl-default-1" -> null
        - created             = "2024-09-17 07:17:26 +0000 UTC" -> null
        - flavor_id           = "b128b802-3d12-401d-bf51-878122c0e908" -> null
        - flavor_name         = "m1.small" -> null
        - force_delete        = false -> null
        - id                  = "4012ffb2-e63c-4e42-992d-759062755877" -> null
        - image_id            = "70cbfbe4-0f7b-4d59-893a-f740537ad5ef" -> null
        - image_name          = "GOLD Alma Linux 9" -> null
        - key_pair            = "mykey" -> null
        - name                = "test-server" -> null
        - power_state         = "active" -> null
        - region              = "osl" -> null
        - security_groups     = [
            - "default",
            - "ssh_icmp_login.uio.no",
          ] -> null
        - stop_before_destroy = false -> null
        - tags                = [] -> null
        - updated             = "2024-09-17 07:17:37 +0000 UTC" -> null
  
        - network {
            - access_network = false -> null
            - fixed_ip_v4    = "10.2.0.117" -> null
            - fixed_ip_v6    = "[2001:700:2:8201::10de]" -> null
            - mac            = "fa:16:3e:e2:2a:c6" -> null
            - name           = "IPv6" -> null
            - uuid           = "62421b56-346d-4794-99b0-fc27fe4e700f" -> null
              # (1 unchanged attribute hidden)
          }
      }
  
  Plan: 0 to add, 0 to change, 1 to destroy.
  
  Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.
  
    Enter a value: yes
  
  openstack_compute_instance_v2.test-server: Destroying... [id=4012ffb2-e63c-4e42-992d-759062755877]
  openstack_compute_instance_v2.test-server: Still destroying... [id=4012ffb2-e63c-4e42-992d-759062755877, 10s elapsed]
  openstack_compute_instance_v2.test-server: Destruction complete after 10s
  
  Destroy complete! Resources: 1 destroyed.

And the instance is gone.
