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
