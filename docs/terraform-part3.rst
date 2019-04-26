.. |date| date::

Terraform and UH-IaaS: Part III - Dynamics
==========================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/
.. _Part 1: terraform-part1.html
.. _Part 2: terraform-part2.html

This document builds on Terraform `Part 1`_ and `Part 2`_, and extends
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
   :emphasize-lines: 2,11-16

Notice that the **region** variable is empty and doesn't have a
default value. For this reason, the region must always be specified in
some way when running Terraform:

.. code-block:: console

  $ ~/terraform plan
  var.region
    Enter a value: 

As shown above, when a default value isn't specified in the code
Terraform will ask for it interactively.

Also note that the **allow_ssh_from_v6** and **allow_ssh_from_v4**
variables are empty lists. It is expected that we specify these in the
``local.tfvars`` file, explained in the next section.


Local variables
---------------

Terraform supports specification of local variables that completes or
overrides the variable set given in :ref:`variables-tf`. We can do
this on command line:

.. code-block:: console

  terraform -var 'region=bgo'

This does not scale, however. Terraform has an option ``-var-file``
that takes one argument, a variables file:

.. code-block:: console

  terraform -var-file <file>

An example file :download:`local.tfvars <downloads/local.tfvars>` that
complements our :ref:`variables-tf` could look like this:

.. literalinclude:: downloads/local.tfvars
   :caption: local.tfvars
   :name: local-tfvars
   :linenos:

Here, we specify the region and the addresses to be used for the
security group. We would use this file like this:

.. code-block:: console

  $ terraform plan -var-file local.tfvars
  $ terraform apply -var-file local.tfvars


Using variables
---------------

Terraform supports a variety of different variable types, and should
be familiar to anyone who has used modern programming languages. We're
using string, list (array) and map (hash) variables:

.. literalinclude:: downloads/main.tf
   :caption: main.tf
   :name: main-tf
   :linenos:


