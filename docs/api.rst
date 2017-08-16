.. |date| date::

OpenStack API
=============

Last changed: |date|

.. contents::

You will get a password when you do the initial first login
(see :doc:`login`). Please make sure you write this down for later
user. If you where an early adopter or forgot your password please contact us.

OpenStack Command Line Interface (CLI)
--------------------------------------

.. _Installing the Openstack command-line clients: http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html

Installing the CLI tools
~~~~~~~~~~~~~~~~~~~~~~~~

Before using the command line tools, they need to be installed. A
relatively recent version of the command line tools are available
natively on some Linux distributions.

**Fedora Linux**
  Installing on Fedora is simple, using the native package manager:

  .. code-block:: console

    # dnf install python-openstackclient

**RHEL7 at UiO**
  In order to install the CLI tools on RHEL7, you need to enable the
  proper repository using **subscription-manager**:

  .. code-block:: console

    # subscription-manager repos --enable=rhel-7-workstation-openstack-11-tools-rpms

  Then, install the CLI tools using yum:

  .. code-block:: console

    # yum install python-openstackclient

**Other Linux, Apple MacOS and Microsoft Windows**
  Follow this guide: `Installing the Openstack command-line clients`_


Using the CLI tools
~~~~~~~~~~~~~~~~~~~

After you receive your password for API access you can use the OpenStack
command line interface (OpenStack CLI) to test the access.

Create a :file:`keystone_rc.sh` file:

.. code-block:: bash

  export OS_USERNAME=<email>
  export OS_PROJECT_NAME=<email>
  export OS_PASSWORD=<password>
  export OS_AUTH_URL=https://api.uh-iaas.no:5000/v3
  export OS_IDENTITY_API_VERSION=3
  export OS_USER_DOMAIN_NAME=dataporten
  export OS_PROJECT_DOMAIN_NAME=dataporten
  export OS_REGION_NAME=<bgo|osl>
  export OS_NO_CACHE=1

Make sure *<email>* is the same as the one used by FEIDE. You'll also
have to choose between the "bgo" and "osl" regions.

This file :file:`keystone_rc.sh` contains your API password, and
should be protected. At a minimum, make sure that you are the only one
with read and write access:

.. code-block:: console

  $ chmod 0600 keystone_rc.sh

When this file has been created, you should be able to source it and
run openstack commands:

.. code-block:: console

  $ source keystone_rc.sh
  $ openstack server list
  +--------------------------------------+------+--------+----------------------+------------+
  | ID                                   | Name | Status | Networks             | Image Name |
  +--------------------------------------+------+--------+----------------------+------------+
  | 5a102c14-83fd-4788-939e-bb2e635e49de | test | ACTIVE | public=158.39.77.147 | Fedora 24  |
  +--------------------------------------+------+--------+----------------------+------------+

Read more about the OpenStack CLI at http://docs.openstack.org/cli-reference/
