==============
Object storage
==============

.. IMPORTANT::
   The object storage is only available as a pilot services. Do not use it
   for important data.

.. contents::

.. _s3tool: https://s3tools.org/usage

Access
======

To gain access to the object storage pilot service please send an email to
support@uh-iaas.no and tell us the name of the project and what you want
to use the object storage for.

Usage
=====

Our object storage support two different API:

* Openstack swift
* AWS S3

Dashboard (swift)
-----------------

This is a simple web GUI where you can create containers (buckets) and upload
and download files.


Openstack cli (swift)
---------------------

You will need to install the python swiftclient for openstack. You will then
be able to create containers (buckets) and upload and download files.

s3cmd (s3)
----------

To use the S3 API you will first need to create ec2 credentials.
With openstack cli (version 3.8+) run:

.. code-block:: console

  openstack ec2 credentials create
  openstack ec2 credentials list
  openstack ec2 credentials show <id>

Install s3cmd and create a config file :file:`~.s3cfg`

.. code-block:: bash

  [default]
  access_key = <access_key>
  host_base = object.api.bgo.uh-iaas.no:8080
  host_bucket = object.api.bgo.uh-iaas.no:8080
  secret_key = <secret_key>

See s3tool_ for more information


Public access (s3)
==================

To access a public object you will first set public ACL. The URL to access it
will be on the form:

.. code-block:: console

  <endpoint>/<project_id>:<bucket>/<path-to-object>

Example:

.. code-block:: console

  https://object.api.bgo.uh-iaas.no:8080/3eae4805dcd6450fb98651f5a9dc9ded:raytest/2018-11-13-raspbian-stretch-lite.img
