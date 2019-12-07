.. |date| date::

Terraform and UH-IaaS: Part V - DNS Management
==============================================

Last changed: |date|

.. contents::

.. _Terraform: https://www.terraform.io/

This document is an introduction on how to create a DNS zone and DNS
records in Openstack using Terraform_.

The files used in this document can be downloaded:

* :download:`zone.tf <downloads/tf-example5/zone.tf>`
* :download:`recordset.tf <downloads/tf-example5/recordset.tf>`


Creating a DNS zone
-------------------

It is quite easy to create a DNS zone using Terraform. Consider
:ref:`zone-tf` below. It is a single resource declaration needed to
create a zone.

.. IMPORTANT::

   The DNS service expects the zone name to be a fully qualified
   domain name, which means that the name of the zone provided in the
   resource declaration must end with a dot "**.**". Omitting the
   trailing dot will result in an error. This is correct:

   `**name = "google.com."**`

   This is incorrect and will not work:

   .. code-block:: console

     name = "google.com"
   
In this example we create a zone "tralala.no":

.. literalinclude:: downloads/tf-example5/zone.tf
   :caption: zone.tf
   :name: zone-tf
   :linenos:

This is all that is needed. You may add additional parameters, most
commonly **TTL**, if you need to set a TTL value other than the
default (3600).

Creating DNS records
--------------------

In this example we create 3 records in the "tralala.no" zone:

#. An **A** record which poinst to a single IPv4 address for
   "test01.tralala.no"
#. An **AAAA** record which points to a single IPv6 address for
   "test01.tralala.no"
#. A **CNAME** record (alias) "www" which points to "test01.tralala.no"

The record resources are specified in the :ref:`recordset-tf` file
below:

.. literalinclude:: downloads/tf-example5/recordset.tf
   :caption: recordset.tf
   :name: recordset-tf
   :linenos:

.. IMPORTANT::

   The DNS service expects the record name to be a fully qualified
   domain name, which means that the name of the record provided in
   the resource declaration must end with a dot "**.**". Omitting the
   trailing dot will result in an error. This is correct:

   .. code-block:: console

     name = "app-01.google.com."

   This is incorrect and will not work:

   .. code-block:: console

     name = "app-01.google.com"

   This also applies to the records list in case of a CNAME, as show
   in the example above.

Apply and check
---------------

Running **terraform apply** creates the zone, as well as the three
records we specified:

.. code-block:: console

  $ terraform apply
  ...
  Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

We can check that the authoritative name servers have our zone and
records by querying one of them them directly:

.. code-block:: console

  $ host www.tralala.no. ns1.uh-iaas.no
  Using domain server:
  Name: ns1.uh-iaas.no
  Address: 158.37.63.251#53
  Aliases: 
  
  www.tralala.no is an alias for test01.tralala.no.
  test01.tralala.no has address 10.0.0.1
  test01.tralala.no has IPv6 address 2001:700:2:8200::226c

As always, you can use **terraform destroy** to remove the created
resources:

.. code-block:: console

  $ terraform destroy
  ...
  Destroy complete! Resources: 4 destroyed.

