.. |date| date::

Terraform and UH-IaaS: Part II - Multiple instances
===================================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Terraform and UH-IaaS\: Part I - Basics: terraform-part1.html

This document describes how to create and manage several instances
(virtual machines) using Terraform_. This document builds on
`Terraform and UH-IaaS\: Part I - Basics`_.


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

.. literalinclude:: downloads/multiple.tf
   :caption: multiple.tf
   :name: multiple-tf
   :linenos:
   :emphasize-lines: 4-5

This file can be downloaded here: :download:`multiple.tf
<downloads/multiple.tf>`.

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


Security groups
---------------

In all the previous examples, we use existing security groups when
provisioning instances. We can use Terraform to create security groups
on the fly for us to use:

.. literalinclude:: downloads/secgroup.tf
   :caption: secgroup.tf
   :name: secgroup-tf
   :linenos:
