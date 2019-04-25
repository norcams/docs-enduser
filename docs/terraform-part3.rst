.. |date| date::

Terraform and UH-IaaS: Part III - Dynamics
==========================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Part I: terraform-part1.html
.. _Part I: terraform-part2.html

This document builds on Terraform `Part I`_ and `Part 2`_, and extends
the code base to make it more dynamic. We also make use of more
advanced functionality in Terraform_ such as output handling and local
variables.


Variables
---------

In order to keep the management of the Terraform infrastructure easy
and intuitive, it is a good idea to consolidate definitions and
variables into a single file or a small set of files. Terraform
supports a concept of default values for variables, which can be
overridden. In our example, we are opting for a single file that
contains all variables, with default values, used throughout the code:

.. literalinclude:: downloads/variables.tf
   :caption: variables.tf
   :name: variables-tf
   :linenos:

Notice that the **region** variable is empty and doesn't have a
default value. For this reason, the region must always be specified in
a way when running Terraform. This is one way of doing Terraform in a
multi-region environment.

