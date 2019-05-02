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

The goal with this document is to show how Terraform can be used to
set up a real environment on UH-IaaS. We will create:

* An SSH key pair
* Four web servers running CentOS
* One database server running Ubuntu
* A volume that is attached to the database server
* Security groups that allows access to the different servers, as well
  as allowing the web servers to access the database server

The files used in this document can be downloaded:

* :download:`main.tf <downloads/tf-example3/main.tf>`
* :download:`secgroup.tf <downloads/tf-example3/secgroup.tf>`
* :download:`variables.tf <downloads/tf-example3/variables.tf>`
* :download:`local.tfvars <downloads/tf-example3/local.tfvars>`


Variables file
--------------

In order to keep the management of the Terraform infrastructure easy
and intuitive, it is a good idea to consolidate definitions and
variables into a single file or a small set of files. Terraform
supports a concept of default values for variables, which can be
overridden. In our example, we are opting for a single file that
contains all variables, with default values, used throughout the code:

.. literalinclude:: downloads/tf-example3/variables.tf
   :caption: variables.tf
   :linenos:
   :emphasize-lines: 2,9-14

Notice that the **region** variable (highlighted) is empty and doesn't
have a default value. For this reason, the region must always be
specified in some way when running Terraform:

.. code-block:: console

  $ ~/terraform plan
  var.region
    Enter a value: 

As shown above, when a default value isn't specified in the code
Terraform will ask for it interactively.

Also note that the **allow_ssh_from_v6**, **allow_ssh_from_v4**
etc. (highlighted) variables are empty lists. It is expected that we
specify these in the ``local.tfvars`` file, explained in the next
section.


Local variables file
--------------------

Terraform supports specification of local variables that completes or
overrides the variable set given in :ref:`variables-tf`. We can do
this on command line:

.. code-block:: console

  terraform -var 'region=bgo'

This does not scale, however. Terraform has an option ``-var-file``
that takes one argument, a variables file:

.. code-block:: console

  terraform -var-file <file>

An example file :download:`local.tfvars <downloads/tf-example3/local.tfvars>` that
complements our :ref:`variables-tf` could look like this:

.. literalinclude:: downloads/tf-example3/local.tfvars
   :caption: local.tfvars
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
using string, list (array) and map (hash) variables. In this example,
we have divided our original one-file setup into 3 files, in addition
to the local variables file:

+------------------+-------------------------------------------------+
| **main.tf**      |Our main file.                                   |
+------------------+-------------------------------------------------+
| **secgroup.tf**  |Since the security group definitions are rather  |
|                  |verbose, we have separated these from the main   |
|                  |file.                                            |
+------------------+-------------------------------------------------+
| **variables.tf** |Variable definitions with default values.        |
+------------------+-------------------------------------------------+
| **local.tfvars** |Local variables.                                 |
+------------------+-------------------------------------------------+

We'll take a look at :ref:`main-tf`. The first part, containing the SSH
key pair resource, is as before but using variables:

.. literalinclude:: downloads/tf-example3/main.tf
   :caption: main.tf
   :linenos:
   :lines: 1-8

Next, we'll look at our security groups in :ref:`secgroup-tf`. We now
have three of them:

.. literalinclude:: downloads/tf-example3/secgroup.tf
   :caption: secgroup.tf
   :linenos:
   :lines: 1-20

Since these are web and database serves, we create a security group
for allowing HTTP for the web servers and port 3306 for the database
server, in addition to allowing SSH and ICMP. The security group rules
for SSH and ICMP are pretty much the same as before, but using
variables:

.. literalinclude:: downloads/tf-example3/secgroup.tf
   :caption: secgroup.tf
   :linenos:
   :lines: 22-68

Notice that we now use implicit iteration over the number of entries
listed in the "allow_from" variables, which are empty lists in
:ref:`variables-tf` but is properly defined in :ref:`local-tfvars`.

Let's take a look at the security group rules defined for HTTP and
MySQL access:

.. literalinclude:: downloads/tf-example3/secgroup.tf
   :caption: secgroup.tf
   :linenos:
   :lines: 70-120

The resource definition for the HTTP access, as well as the first two
resource definitions for MySQL access, follows the same logic as that
of the SSH and ICMP rules. The last two MySQL rules are different:

.. literalinclude:: downloads/tf-example3/secgroup.tf
   :caption: secgroup.tf
   :linenos:
   :lines: 122-
   :emphasize-lines: 10,23

Here, we use rather advanced functionality for security groups in
Openstack. We can allow IP addresses from other security groups
(source groups) access by specifying ``remote_group_id`` rather than
``remote_ip_prefix``. It is possible to achieve the same using
``remote_ip_prefix``, however it is less elegant [#f1]_.

We'll circle back to :ref:`main-tf`:

.. literalinclude:: downloads/tf-example3/main.tf
   :caption: main.tf
   :linenos:
   :lines: 10-58

We now define two different instance resources. One for web servers
and one for the database server. They use different values defined in
:ref:`variables-tf` for image, flavor etc. Lastly, we define a volume
resource and attach this volume to the database server:

.. literalinclude:: downloads/tf-example3/main.tf
   :caption: main.tf
   :linenos:
   :lines: 60-


Making changes
--------------

Terraform maintains the state of the infrastructure it manages in the
workspace directory. It is possible to make simple changes just by
updating and applying the code. If we wanted to scale down the number
of web servers from 4 to 2, we would change this line in
:ref:`variables-tf`:

.. literalinclude:: downloads/tf-example3/variables.tf
   :caption: variables.tf
   :linenos:
   :lines: 34-
   :emphasize-lines: 5

After changing the count from **4** to **2** here (the highlighted
line), we can run ``terraform plan``:

.. code-block:: console

  $ terraform plan -var-file local.tfvars
  ...
  Terraform will perform the following actions:
  
    - openstack_compute_instance_v2.web_instance[2]
  
    - openstack_compute_instance_v2.web_instance[3]
    
  
  Plan: 0 to add, 0 to change, 2 to destroy.
  ...

Applying this with ``terraform apply`` will then destroy two of the
web servers. Similarly, if we were to increase the web server count
from **4** to **5**, Terraform would add a new web server.


Complete example
----------------

A complete listing of the example files used in this document is
provided below.

.. literalinclude:: downloads/tf-example3/main.tf
   :caption: main.tf
   :name: main-tf
   :linenos:

.. literalinclude:: downloads/tf-example3/secgroup.tf
   :caption: secgroup.tf
   :name: secgroup-tf
   :linenos:

.. literalinclude:: downloads/tf-example3/variables.tf
   :caption: variables.tf
   :name: variables-tf
   :linenos:

.. literalinclude:: downloads/tf-example3/local.tfvars
   :caption: local.tfvars
   :name: local-tfvars
   :linenos:

.. rubric:: Footnotes

.. [#f1] An alternative way to dynamically add access for the web servers,
   by using ``remote_ip_prefix``, would be to make use of the computed
   value for the instance IPv4 and IPv6 addresses given to the web
   servers when provisioned:

   .. literalinclude:: downloads/tf-example3/alternative-secgroup.tf
      :caption: secgroup alternative
      :linenos:
