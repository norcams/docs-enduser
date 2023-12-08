==============
Object Storage
==============

.. IMPORTANT::
   The object storage is only available as a **PILOT SERVICE**. Do not
   use it for important data. The service is available in the BGO and
   OSL regions.

.. WARNING::
   At this point in time, due to physical constraints on the backing
   hardware, the object storage service is not suited for
   very high volume usage. If you need either a high volume of objects, a
   high volume of transactions, or a high volume of storage capacity,
   please reach out to the NREC team in our slack channel, or via an
   email to support@nrec.no.

.. contents::

.. _Amazon S3 Tools: https://s3tools.org/usage
.. _AWS CLI: https://docs.aws.amazon.com/cli/
.. _OpenStack Swift: https://docs.openstack.org/swift/latest/
.. _Amazon S3: https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
.. _EPEL: https://docs.fedoraproject.org/en-US/epel/

Access
======

To gain access to the object storage pilot service please send an email to
support@nrec.no and tell us the name of the project that should have
access to object storage.

Usage
=====

Our object storage support two different APIs:

* `OpenStack Swift`_
* `Amazon S3`_

The endpoint URLs are

.. code-block:: console

  https://object.api.bgo.nrec.no:8080
  https://object.api.osl.nrec.no:8080

for the BGO and OSL regions respectively.


Dashboard (Swift)
-----------------

This is a simple web GUI where you can create containers (buckets) and upload
and download files.


Openstack CLI (Swift)
---------------------

You will need to install the python swiftclient for openstack. You will then
be able to create containers (buckets) and upload and download files.

* For Fedora and RHEL, Alma Linux, Rocky Linux and CentOS Stream 8.x and later:

  .. code-block:: console

    # yum install python3-swiftclient


Amazon S3 Tools: s3cmd (S3)
---------------------------

.. WARNING::
  Make sure you have :file:`export OS_INTERFACE=public` in your RC-file used
  with openstack cli

To use the S3 API you will first need to create EC2 credentials.
With openstack cli (version 3.8+) run:

.. code-block:: console

  openstack ec2 credentials create
  openstack ec2 credentials list
  openstack ec2 credentials show <id>

Install s3cmd:

* For Fedora and RHEL, Alma Linux, Rocky Linux and CentOS Stream 8.x
  and later with EPEL_ enabled:

  .. code-block:: console

    # yum install s3cmd

and create a config file :file:`~.s3cfg`

.. code-block:: bash

  [default]
  access_key = <access_key>
  host_base = object.api.bgo.nrec.no:8080
  host_bucket = object.api.bgo.nrec.no:8080
  secret_key = <secret_key>

See `Amazon S3 Tools`_ for more information

AWS CLI (S3)
------------

`AWS CLI`_ can be installed on Fedora and RHEL, Alma Linux, Rocky
  Linux and CentOS Stream 8.x and later with EPEL_ enabled:

  .. code-block:: console

    # yum install awscli

You need to create EC2 credentials, as described for the s3cmd usage. Configuration
of the `AWS CLI`_ may be performed in several ways. A simple method is to use
environment variables:

.. code-block:: bash

  export AWS_ACCESS_KEY_ID=<access_key>
  export AWS_SECRET_ACCESS_KEY=<secret_key>
  export AWS_ENDPOINT_URL=https://object.api.bgo.nrec.no:8080

See `AWS CLI`_ for more information.

Public Access (S3)
==================

To access a public object you will first set public ACL. The URL to access it
will be on the form:

.. code-block:: console

  <endpoint>/<project_id>:<bucket>/<path-to-object>

Example:

.. code-block:: console

  https://object.api.bgo.nrec.no:8080/<project-id>:<bucket>/<object>

Object Locking (S3)
===================

Using the S3 object lock mechanism, you can use object lock concepts like retention
period, legal hold, and bucket configuration to implement Write-Once-Read_Many (WORM)
functionality. In the following example we will use `AWS CLI`_ to create a bucket and
configure object locking for new objects put there.

.. IMPORTANT::
   The object version(s), not the object name, is the defining and required value
   for object lock to perform correctly to support the **GOVERNANCE** or **COMPLIANCE**
   mode. You need to know the version of the object when it is written so that you can
   retrieve it at a later time.

First, create a bucket and enable object locking for the new bucket.

.. code-block:: console

  aws s3api create-bucket --bucket myimportantbackup --object-lock-enabled-for-bucket

Set a retention period for the bucket. In this example, we set a 30 days retention
period. This will be the default for new objects put into this bucket.

.. code-block:: console

  $ aws s3api put-object-lock-configuration --bucket myimportantbackup \
  --object-lock-configuration '{ "ObjectLockEnabled": "Enabled", \
  "Rule": { "DefaultRetention": { "Mode": "GOVERNANCE", "Days": 30 }}}'

.. NOTE::
  You can choose either the **GOVERNANCE** or **COMPLIANCE** mode for the ``RETENTION_MODE`` in S3
  object lock, to apply different levels of protection to any object version that is protected
  by object lock.

  In **GOVERNANCE** mode, users cannot overwrite or delete an object version or alter its lock
  settings unless they have special permissions.

  In **COMPLIANCE** mode, a protected object version cannot be overwritten or deleted by any user.
  When an object is locked in **COMPLIANCE** mode, its ``RETENTION_MODE`` cannot be changed, and
  its retention period cannot be shortened. **COMPLIANCE** mode helps ensure that an object version
  cannot be overwritten or deleted for the duration of the period.

Put an object into det bucket with a specific retention time set:

.. code-block:: console

  $ aws s3api put-object --bucket myimportantbackup --object-lock-mode GOVERNANCE \
  --object-lock-retain-until-date "2023-12-30" --key governance-upload --body /tmp/testfile1

  {
      "ETag": "\"224585ee94754d3d9095726275da863b\"",
      "VersionId": "BT5ILU5W8KCqi5BXHOptVDFb.JyHXFc"
  }

Now upload another object, using the same key:

.. code-block:: console

  $ aws s3api put-object --bucket myimportantbackup --object-lock-mode GOVERNANCE \
  --object-lock-retain-until-date "2023-12-30" --key governance-upload --body /tmp/testfile2

  {
      "ETag": "\"404290d1d1cad1390cd77a0a56c960ec\"",
      "VersionId": "ynk5tyro6BufAQaKfPA0yg3vY6lKAh6"
  }

List the object versions from the bucket:

.. code-block:: console

  $ aws s3api list-object-versions --bucket myimportantbackup

  {
    "Versions": [
      {
          "ETag": "\"404290d1d1cad1390cd77a0a56c960ec\"",
          "Size": 126720,
          "StorageClass": "STANDARD",
          "Key": "governance-upload",
          "VersionId": "ynk5tyro6BufAQaKfPA0yg3vY6lKAh6",
          "IsLatest": true,
          "LastModified": "2023-12-07T14:05:42.423000+00:00",
          "Owner": {
              "DisplayName": "some-nrec-project",
              "ID": "a4549966f6e94851bb991c34aff828f0$a4549966f6e94851bb991c34aff828f0"
          }
      },
      {
          "ETag": "\"224585ee94754d3d9095726275da863b\"",
          "Size": 459164,
          "StorageClass": "STANDARD",
          "Key": "governance-upload",
          "VersionId": "BT5ILU5W8KCqi5BXHOptVDFb.JyHXFc",
          "IsLatest": false,
          "LastModified": "2023-12-07T13:57:10.669000+00:00",
          "Owner": {
              "DisplayName": "some-nrec-project",
              "ID": "a4549966f6e94851bb991c34aff828f0$a4549966f6e94851bb991c34aff828f0"
          }
      }
    ],
    "RequestCharged": null
  }

List only the latest objects:

.. code-block:: console

  $  aws s3api list-objects --bucket myimportantbackup
  {
      "Contents": [
          {
              "Key": "governance-upload",
              "LastModified": "2023-12-07T13:59:58.806000+00:00",
              "ETag": "\"404290d1d1cad1390cd77a0a56c960ec\"",
              "Size": 126720,
              "StorageClass": "STANDARD",
              "Owner": {
                  "DisplayName": "some-nrec-project",
                  "ID": "a4549966f6e94851bb991c34aff828f0$a4549966f6e94851bb991c34aff828f0"
              }
          }
      ],
      "RequestCharged": null
  }
