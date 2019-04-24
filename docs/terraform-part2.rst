.. |date| date::

Terraform and UH-IaaS: Part II - Additional resources
=====================================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Terraform and UH-IaaS\: Part I - Basics: terraform-part1.html

This document describes how to create and manage several instances
(virtual machines) using Terraform_. This document builds on
`Terraform and UH-IaaS\: Part I - Basics`_.

The example file can be downloaded here: :download:`advanced.tf
<downloads/advanced.tf>`.


Multiple instances
------------------

Building on the :download:`basic.tf <downloads/basic.tf>` file
discussed in part I:

.. literalinclude:: downloads/basic.tf
   :caption: basic.tf
   :name: basic-tf
   :linenos:

This file provisions a single instance. We can add a ``count``
directive to specify how many we want to provision. When doing so, we
should also make sure that the instances have unique names, and we
accomplish that by using the count when specifying the instance name:

.. literalinclude:: downloads/advanced.tf
   :linenos:
   :lines: 1-2,55-68
   :emphasize-lines: 57-58

When running this file with ``terraform apply``, a total of 5
instances are created, as expected:

.. code-block:: console

  $ openstack server list -c Name -c Networks -c Image -c Flavor
  +--------+---------------------------------------+---------------+----------+
  | Name   | Networks                              | Image         | Flavor   |
  +--------+---------------------------------------+---------------+----------+
  | test-4 | IPv6=2001:700:2:8201::1033, 10.2.0.51 | GOLD CentOS 7 | m1.small |
  | test-0 | IPv6=2001:700:2:8201::1029, 10.2.0.68 | GOLD CentOS 7 | m1.small |
  | test-2 | IPv6=2001:700:2:8201::1009, 10.2.0.62 | GOLD CentOS 7 | m1.small |
  | test-3 | IPv6=2001:700:2:8201::1027, 10.2.0.36 | GOLD CentOS 7 | m1.small |
  | test-1 | IPv6=2001:700:2:8201::101a, 10.2.0.21 | GOLD CentOS 7 | m1.small |
  +--------+---------------------------------------+---------------+----------+


Key pairs
---------

We can have Terraform automatically create a key pair for us, instead
of relying on a preexisting key pair. This is accomplished by creating
a resource block for a key pair:

.. literalinclude:: downloads/advanced.tf
   :linenos:
   :lines: 3-8, 55-68
   :emphasize-lines: 15

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

.. literalinclude:: downloads/advanced.tf
   :linenos:
   :lines: 9-68
   :emphasize-lines: 55

The file listed above can be downloaded here: :download:`secgroup.tf
<downloads/secgroup.tf>`. There are a lot of new stuff in this file
compared to :ref:`multiple-tf`.

#. Line 3-5 contains a resource for a security group. This is pretty
   straightforward and only contains a name and description

#. Line 9-47 contains 4 security group rules. They are all ingress
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
   :emphasize-lines: 6

  $ openstack security group list -c Name -c Description
  +--------------+-------------------------------------------------+
  | Name         | Description                                     |
  +--------------+-------------------------------------------------+
  | RDP          |                                                 |
  | ssh-and-icmp | Security group for allowing SSH and ICMP access |
  | SSH and ICMP |                                                 |
  | default      | Default security group                          |
  +--------------+-------------------------------------------------+

We can also inspect the security group ``ssh-and-icmp`` that we
created, to verify that the specified rules are present:

.. code-block:: console
   :emphasize-lines: 11-16

  $ openstack security group show ssh-and-icmp
  +-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | Field           | Value                                                                                                                                                                                                                                                  |
  +-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | created_at      | 2019-04-24T12:24:35Z                                                                                                                                                                                                                                   |
  | description     | Security group for allowing SSH and ICMP access                                                                                                                                                                                                        |
  | id              | 43863c7f-d105-47a5-afe2-22d74f7a4623                                                                                                                                                                                                                   |
  | name            | ssh-and-icmp                                                                                                                                                                                                                                           |
  | project_id      | b56e80c7c777419585b13ebafe024330                                                                                                                                                                                                                       |
  | revision_number | 6                                                                                                                                                                                                                                                      |
  | rules           | created_at='2019-04-24T12:24:35Z', direction='egress', ethertype='IPv6', id='53bfef03-fea6-4504-a996-69c12f5c00bd', updated_at='2019-04-24T12:24:35Z'                                                                                                  |
  |                 | created_at='2019-04-24T12:24:35Z', direction='egress', ethertype='IPv4', id='7565bdf1-827a-4736-ba1c-dab822037c4b', updated_at='2019-04-24T12:24:35Z'                                                                                                  |
  |                 | created_at='2019-04-24T12:24:36Z', direction='ingress', ethertype='IPv4', id='93458178-15b1-4ae5-bee0-225ae56aeeef', port_range_max='22', port_range_min='22', protocol='tcp', remote_ip_prefix='129.240.0.0/16', updated_at='2019-04-24T12:24:36Z'    |
  |                 | created_at='2019-04-24T12:24:36Z', direction='ingress', ethertype='IPv4', id='9d1724ae-c375-4b64-98ec-43d0f6b58383', protocol='icmp', remote_ip_prefix='129.240.0.0/16', updated_at='2019-04-24T12:24:36Z'                                             |
  |                 | created_at='2019-04-24T12:24:36Z', direction='ingress', ethertype='IPv6', id='b0d110ad-8e43-4493-a178-a3ef56854c20', protocol='icmp', remote_ip_prefix='2001:700:100::/40', updated_at='2019-04-24T12:24:36Z'                                          |
  |                 | created_at='2019-04-24T12:24:37Z', direction='ingress', ethertype='IPv6', id='e7131d6e-9a56-43ca-819d-bd3428013b44', port_range_max='22', port_range_min='22', protocol='tcp', remote_ip_prefix='2001:700:100::/40', updated_at='2019-04-24T12:24:37Z' |
  | updated_at      | 2019-04-24T12:24:37Z                                                                                                                                                                                                                                   |
  +-----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Volumes
-------

Creating volumes is often required, and Terraform can do that as
well. In order to create a volume you will define the resource:

.. literalinclude:: downloads/advanced.tf
   :linenos:
   :lines: 70-74

Here, we create a volume named "my-volume" with a size of 10 GB. We
also want to attach the volume to one of our instances:

.. literalinclude:: downloads/advanced.tf
   :linenos:
   :lines: 76-80

In this example, we choose to attach the volume to instance number 0,
which is the instance named "test-0". We can inspect using Openstack
CLI:

.. code-block:: console

  $ openstack volume list
  +--------------------------------------+-----------+--------+------+---------------------------------+
  | ID                                   | Name      | Status | Size | Attached to                     |
  +--------------------------------------+-----------+--------+------+---------------------------------+
  | b75b654e-bd74-4796-9405-27ca2e056e96 | my-volume | in-use |   10 | Attached to test-0 on /dev/sdb  |
  +--------------------------------------+-----------+--------+------+---------------------------------+
