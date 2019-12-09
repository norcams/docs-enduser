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
* :download:`dynamic.tf <downloads/tf-example5/dynamic.tf>`


Creating a DNS zone
-------------------

It is quite easy to create a DNS zone using Terraform. Consider
:ref:`zone-tf` below. It is a single resource declaration needed to
create a zone.

.. IMPORTANT::

   The DNS service expects the zone name to be a fully qualified
   domain name, which means that the name of the zone provided in the
   resource declaration must end with a dot "**.**". Omitting the
   trailing dot will result in an error.

   This is correct:

   ``name = "google.com."``

   This is incorrect and will not work:

   ``name = "google.com"``
   
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

   ``name = "app-01.google.com."``

   This is incorrect and will not work:

   ``name = "app-01.google.com"``

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


Dynamically add DNS records
---------------------------

The previous examples show how to add a zone and create records within
that zone. What if the zone already exists, and how do we
automatically add a DNS record for an instance when the instance is
created? We'll answer those questions here.

First, let's consider how to add records to an already existing
zone. The problem here is that we need to know the ID of the zone. We
can manually fetch the ID from the output of ``openstack zone list``
and hard code the ID into our Terraform config, but there is a more
dynamic and flexible way to do this. In order to fetch the needed
metadata for our zone we use a ``data`` directive in Terraform:

.. literalinclude:: downloads/tf-example5/dynamic.tf
   :caption: dynamic.tf
   :linenos:
   :lines: 3-7,34-37

In this example, we have a resource declaration for instances that
creates an arbitrary number of instances. In our example, we create 2
instances:

.. literalinclude:: downloads/tf-example5/dynamic.tf
   :caption: dynamic.tf
   :linenos:
   :lines: 13-32

Finally, in order to create DNS records for our instances we need to
reference the name and IP of the instances:

.. literalinclude:: downloads/tf-example5/dynamic.tf
   :caption: dynamic.tf
   :linenos:
   :lines: 39-

In this example, we create both **A** (IPv4) and **AAAA** (IPv6)
records for our instances, since we specified the "dualStack"
network for the instance resources.

After running ``terraform apply`` we can use the CLI command
``openstack recordset list`` to verify that the DNS records have been
created:

.. code-block:: console

  $ openstack recordset list mytestzone.com. -c name -c type -c records
  +----------------------------+-------+-------------------------------------------------------------+
  | name                       | type  | records                                                     |
  +----------------------------+-------+-------------------------------------------------------------+
  | mytestzone.com.            | SOA   | ns2.uh-iaas.no. foo.bar.com. 1575885141 3519 600 86400 3600 |
  | mytestzone.com.            | NS    | ns1.uh-iaas.no.                                             |
  |                            |       | ns2.uh-iaas.no.                                             |
  | bgo-test-1.mytestzone.com. | A     | 158.39.74.137                                               |
  | bgo-test-0.mytestzone.com. | AAAA  | 2001:700:2:8300::21d3                                       |
  | bgo-test-1.mytestzone.com. | AAAA  | 2001:700:2:8300::207e                                       |
  | bgo-test-0.mytestzone.com. | A     | 158.39.77.244                                               |
  +----------------------------+-------+-------------------------------------------------------------+

And we can check that they exist in DNS by querying the authoritative
name servers:

.. code-block:: console

  $ host bgo-test-1.mytestzone.com. ns1.uh-iaas.no
  Using domain server:
  Name: ns1.uh-iaas.no
  Address: 158.37.63.251#53
  Aliases: 
  
  bgo-test-1.mytestzone.com has address 158.39.74.137
  bgo-test-1.mytestzone.com has IPv6 address 2001:700:2:8300::207e


Complete example
----------------

A complete listing of the example files used in this document is
provided below.

.. literalinclude:: downloads/tf-example5/zone.tf
   :caption: zone.tf
   :name: zone-tf
   :linenos:

.. literalinclude:: downloads/tf-example5/recordset.tf
   :caption: recordset.tf
   :name: recordset-tf
   :linenos:

.. literalinclude:: downloads/tf-example5/dynamic.tf
   :caption: dynamic.tf
   :name: dynamic-tf
   :linenos:
