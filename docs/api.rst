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

After you receive your password for API access you can use the OpenStack
command line interface (OpenStack CLI) to test the access.

Create a ::file:`keystone_rc.sh` file:

.. code-block:: bash

  export OS_USERNAME=<email>
  export OS_TENANT_NAME=<email>
  export OS_PASSWORD=<password>
  export OS_AUTH_URL=https://api.uh-iaas.no:5000/v3
  export OS_IDENTITY_API_VERSION=3
  export OS_USER_DOMAIN_NAME=dataporten
  export OS_PROJECT_DOMAIN_NAME=dataporten
  export OS_REGION_NAME=<bgo|osl>
  export OS_NO_CACHE=1

Make sure *<email>* is the same as the one used by FEIDE. You'll also
have to choose between the "bgo" and "osl" regions. 

Install the openstack cli for your system. More help on `Installing the Openstack cli
<http://docs.openstack.org/cli-reference/common/cli_install_openstack_command_line_clients.html>`_

.. code-block:: console

  $ source keystone_rc.sh
  $ openstack server list
  +--------------------------------------+------+--------+----------------------+------------+
  | ID                                   | Name | Status | Networks             | Image Name |
  +--------------------------------------+------+--------+----------------------+------------+
  | 5a102c14-83fd-4788-939e-bb2e635e49de | test | ACTIVE | public=158.39.77.147 | Fedora 24  |
  +--------------------------------------+------+--------+----------------------+------------+

Read more about the OpenStack CLI at http://docs.openstack.org/cli-reference/
