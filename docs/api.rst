.. |date| date::

OpenStack API and CLI (command line interface)
==============================================

Last changed: |date|

.. contents::

.. _access: https://access.nrec.no

You will get a password when you do the initial first login
(see :doc:`login`). Please make sure you write this down for later
use.

If you were an early adopter or forgot your password, you can
reset your password by clicking on "Reset API password" on access_ page.

OpenStack Command Line Interface (CLI)
--------------------------------------

.. _OpenStackClient: https://docs.openstack.org/python-openstackclient/stein/

Installing the CLI tools
~~~~~~~~~~~~~~~~~~~~~~~~

.. _DNS service: dns.html

Before using the command line tools, they need to be installed. A
relatively recent version of the command line tools are available
natively on some Linux distributions. There are also versins available for
other operating systems like Apple OS X and Microsoft Windows. Please
check documentation at OpenStack: `OpenStackClient`_ for more information.

**Fedora Linux**
  Installing on Fedora is simple, using the native package manager:

  .. code-block:: console

    # dnf install python3-openstackclient

  In order to use the `DNS service`_ you also need the designate
  client package:

  .. code-block:: console

    # dnf install python3-designateclient


**RHEL7 or RHEL8 at UiO**
  In order to install the CLI tools on RHEL7 or RHEL8, you need to enable the
  proper repository using **subscription-manager**:

  * For RHEL8:

    .. code-block:: console

      # subscription-manager repos --enable=openstack-16-tools-for-rhel-8-x86_64-rpms

  * For RHEL7 Workstation:

    .. code-block:: console

      # subscription-manager repos --enable=rhel-7-workstation-openstack-14-tools-rpms

  * For RHEL7 Server:

    .. code-block:: console

      # subscription-manager repos --enable=rhel-7-server-openstack-14-tools-rpms

  Then, install the CLI tools using yum:

  * For RHEL8:

    .. code-block:: console

      # yum install python3-openstackclient

  * For RHEL7:

    .. code-block:: console

      # yum install python2-openstackclient

  In order to use the `DNS service`_ you also need the designate
  client package:

  * For RHEL8:

    .. code-block:: console

      # yum install python3-designateclient

  * For RHEL7:

    .. code-block:: console

      # yum install python2-designateclient


Using the CLI tools
~~~~~~~~~~~~~~~~~~~

.. _First time login: http://docs.nrec.no/login.html#first-time-login

After you receive your password for API access you can use the OpenStack
command line interface (OpenStack CLI) to test the access.

Create a :file:`keystone_rc.sh` file:

.. code-block:: bash

  export OS_USERNAME=<feide-id>
  export OS_PROJECT_NAME=<project>
  export OS_PASSWORD=<password>
  export OS_AUTH_URL=https://api.nrec.no:5000/v3
  export OS_IDENTITY_API_VERSION=3
  export OS_USER_DOMAIN_NAME=dataporten
  export OS_PROJECT_DOMAIN_NAME=dataporten
  export OS_REGION_NAME=<region>
  export OS_INTERFACE=public
  export OS_NO_CACHE=1

The above is a template. Replace the following:

* Replace *<feide-id>* with your FEIDE identity, e.g. "username\@uio.no"
* Replace *<project>* with the project name,
  e.g. "DEMO-username.uio.no"
* Replace *<password>* with the API password that you got when first
  logging in. See `First time login`_
* Replace *<region>* with either "osl" or "bgo", whichever you want to
  use.

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
