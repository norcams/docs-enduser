.. |date| date::

Terraform and NREC: Part II - Additional resources
=====================================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Terraform and NREC\: Part I - Basics: terraform-part1.html
.. _Part 1: terraform-part1.html

This document describes how to create and manage several instances
(virtual machines) using Terraform_. This document builds on
`Terraform and NREC\: Part I - Basics`_. While part 1 relied on
preexisting resources such as SSH key pairs and security groups, in
this example we create everything from scratch.

The example file can be downloaded here: :download:`advanced.tf
<downloads/tf-example2/advanced.tf>`.


Image Name
----------

.. _lifecycle meta-argument: https://www.terraform.io/docs/configuration/resources.html#lifecycle-lifecycle-customizations

In `Part 1`_ we used ``image_name`` to specify our preferred image. By
itself this is usually not a good idea, unless for testing
purposes. The "GOLD" images provided in NREC are renewed
(e.g. replaced) each month, and Terraform uses the image ID in its
state. If using Terraform as a oneshot utility to spin up instances,
this isn't a problem.

The consequence of using ``image_name`` to specify the image is that
Terraform's own state becomes outdated when the NREC image is
renamed. When using Terraform at a later time to make changes in the
virtual infrastructure, it will destroy all running instances and
create new ones, in order to comply with the configuration. This is
probably not what you want. Running ``terraform plan`` in this
scenario would output:

.. code-block:: console

  image_name:     "Outdated (CentOS 8)" => "GOLD CentOS 8" (forces new resource)

In order to combat this, we add the following
code snippet to our ``openstack_compute_instance_v2`` resource:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :caption: advanced.tf
   :linenos:
   :lines: 82-84

This `lifecycle meta-argument`_ makes Terraform ignore changes to the
image name. Another approach would be to specify ``image_id`` instead
of ``image_name``. We find the correct ``image_id`` by using the
Openstack CLI:

.. code-block:: console

  $ openstack image list --status active


Multiple instances
------------------

Building on the :download:`basic.tf <downloads/tf-example1/basic.tf>` file
discussed in `Part 1`_:

.. literalinclude:: downloads/tf-example1/basic.tf
   :caption: basic.tf
   :name: basic-tf
   :linenos:

This file provisions a single instance. We can add a ``count``
directive to specify how many we want to provision. When doing so, we
should also make sure that the instances have unique names, and we
accomplish that by using the count when specifying the instance name:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :linenos:
   :lines: 1-15,68-85
   :emphasize-lines: 18-19

When running this file with ``terraform apply``, a total of 5
instances are created, as expected:

.. code-block:: console

  $ openstack server list
  +--------------------------------------+--------+--------+----------------------------------------+---------------+----------+
  | ID                                   | Name   | Status | Networks                               | Image         | Flavor   |
  +--------------------------------------+--------+--------+----------------------------------------+---------------+----------+
  | 1f5381bd-2fd3-4152-85c2-1c18d628831c | test-3 | ACTIVE | IPv6=2001:700:2:8201::1055, 10.2.0.89  | GOLD CentOS 8 | m1.small |
  | 3b0ea0d4-4af5-4963-8e95-4fce12cdaa04 | test-1 | ACTIVE | IPv6=2001:700:2:8201::1421, 10.2.0.97  | GOLD CentOS 8 | m1.small |
  | 83740a1d-b5db-412e-bf73-815a00a5fd8e | test-0 | ACTIVE | IPv6=2001:700:2:8201::1400, 10.2.1.156 | GOLD CentOS 8 | m1.small |
  | 87d92714-c375-489f-abe8-887491dfc0af | test-4 | ACTIVE | IPv6=2001:700:2:8201::149b, 10.2.1.172 | GOLD CentOS 8 | m1.small |
  | 3b80d3a2-8883-41ea-9d36-7dc9db874f26 | test-2 | ACTIVE | IPv6=2001:700:2:8201::13af, 10.2.3.110 | GOLD CentOS 8 | m1.small |
  +--------------------------------------+--------+--------+----------------------------------------+---------------+----------+


Key pairs
---------

We can have Terraform automatically create a key pair for us, instead
of relying on a preexisting key pair. This is accomplished by creating
a resource block for a key pair:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :linenos:
   :lines: 16-21, 68-85
   :emphasize-lines: 14

After running Terraform, we can verify that the key has been created:

.. code-block:: console

  $ openstack keypair list
  +------------------+-------------------------------------------------+
  | Name             | Fingerprint                                     |
  +------------------+-------------------------------------------------+
  | my-terraform-key | e2:2e:26:7f:5d:98:9e:8f:5e:fd:c7:d5:d0:6b:44:e7 |
  | mykey            | e2:2e:26:7f:5d:98:9e:8f:5e:fd:c7:d5:d0:6b:44:e7 |
  +------------------+-------------------------------------------------+


Security groups
---------------

In all the previous examples, we use existing security groups when
provisioning instances. We can use Terraform to create security groups
on the fly for us to use:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :linenos:
   :lines: 22-85
   :emphasize-lines: 55

There is a lot of new stuff here:

#. Line 2-5 contains a resource for a security group. This is pretty
   straightforward and only contains a name and description

#. Line 8-45 contains 4 security group rules. They are all ingress
   rules (e.g. incoming traffic) and allows for SSH and ICMP from the
   UiO IPv4 and IPv6 networks.

#. The ``security_group_id`` is a required field which specifies the
   security group where the rule shall be applied, and we use the
   Terraform object notation to specify the security group we created
   earlier.

As before, 5 instances are created. In addition a new security group
is created, with the name and description as specified in the
Terraform file:

.. code-block:: console

  $ openstack security group list -c Name -c Description
  +--------------------------------+--------------------------------------+
  | Name                           | Description                          |
  +--------------------------------+--------------------------------------+
  | uio-ssh-icmp                   | Allow SSH and ICMP access from UiO   |
  | SSH and ICMP from login.uio.no | Allow ssh and ping from login.uio.no |
  | default                        | Default security group               |
  +--------------------------------+--------------------------------------+

We can also inspect the security group ``uio-ssh-icmp`` that we
created, to verify that the specified rules are present:

.. code-block:: console

  $ openstack security group rule list --long uio-ssh-icmp
  +--------------------------------------+-------------+-------------------+------------+-----------+-----------+-----------------------+
  | ID                                   | IP Protocol | IP Range          | Port Range | Direction | Ethertype | Remote Security Group |
  +--------------------------------------+-------------+-------------------+------------+-----------+-----------+-----------------------+
  | 391b4869-e900-44d8-9b7e-77318b9484ba | ipv6-icmp   | 2001:700:100::/41 |            | ingress   | IPv6      | None                  |
  | 6f06e10a-99d8-4e3b-9dd3-6b20ff43aa28 | tcp         | 2001:700:100::/41 | 22:22      | ingress   | IPv6      | None                  |
  | 88e6d5cf-1479-45a7-aa3f-8921ef84b939 | None        | None              |            | egress    | IPv4      | None                  |
  | 98827cd8-7461-42c1-af8d-209813a15507 | icmp        | 129.240.0.0/16    |            | ingress   | IPv4      | None                  |
  | 9c37c84c-e06c-4a0f-8f8e-24799210ec99 | tcp         | 129.240.0.0/16    | 22:22      | ingress   | IPv4      | None                  |
  | bf54f0b2-844e-41a7-8f90-a11fb2c808c0 | None        | None              |            | egress    | IPv6      | None                  |
  +--------------------------------------+-------------+-------------------+------------+-----------+-----------+-----------------------+


Volumes
-------

Creating volumes is often required, and Terraform can do that as
well. In order to create a volume you will define the resource:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :linenos:
   :lines: 87-91

Here, we create a volume named "my-volume" with a size of 10 GB. We
also want to attach the volume to one of our instances:

.. literalinclude:: downloads/tf-example2/advanced.tf
   :linenos:
   :lines: 93-97

In this example, we choose to attach the volume to instance number 0,
which is the instance named "test-0". We can inspect using Openstack
CLI:

.. code-block:: console

  $ openstack volume list
  +--------------------------------------+--------------+-----------+------+---------------------------------+
  | ID                                   | Name         | Status    | Size | Attached to                     |
  +--------------------------------------+--------------+-----------+------+---------------------------------+
  | b5240613-404d-4b85-a28b-8ad32f8b0652 | my-volume    | in-use    |   10 | Attached to test-0 on /dev/sdb  |
  +--------------------------------------+--------------+-----------+------+---------------------------------+


Complete example
----------------

A complete listing of the example file :download:`advanced.tf
<downloads/tf-example2/advanced.tf>` used in this document is provided below.

.. literalinclude:: downloads/tf-example2/advanced.tf
   :caption: advanced.tf
   :linenos:
