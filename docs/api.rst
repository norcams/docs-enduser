OpenStack API and CLI (command line interface)
==============================================

Last changed: 2025-04-09

.. contents::

.. _access: https://access.nrec.no

You will get a password when you do the initial first login
(see :doc:`login`). Please make sure you write this down for later
use.

If you were an early adopter or forgot your password, you can
reset your password by clicking on "Reset API password" on access_ page.

OpenStack Command Line Interface (CLI)
--------------------------------------

.. _OpenStackClient: https://docs.openstack.org/python-openstackclient/yoga/

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


**RHEL at UiO**
  In order to install the CLI tools on RHEL, you need to enable the
  proper repository using **subscription-manager**:

  * For RHEL9:

    .. code-block:: console

      # subscription-manager repos --enable=rhoso-tools-18-for-rhel-9-x86_64-rpms

  * For RHEL8:

    .. code-block:: console

      # subscription-manager repos --enable=openstack-17.1-tools-for-rhel-8-x86_64-rpms

  Then, install the CLI tools using yum:

  * For RHEL8 and RHEL9:

    .. code-block:: console

      # yum install python3-openstackclient

  In order to use the `DNS service`_ you also need the designate
  client package:

  * For RHEL8 and RHEL9:

    .. code-block:: console

      # yum install python3-designateclient


Using the CLI tools
~~~~~~~~~~~~~~~~~~~

.. _first logging in: http://docs.nrec.no/login.html#first-time-login
.. _access.nrec.no: https://access.nrec.no/
.. _Feide identity: https://www.feide.no/

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

* Replace *<feide-id>* with your `Feide identity`_, e.g. "username\@uio.no".
* Replace *<project>* with the project name,
  e.g. "DEMO-username.uio.no"
* Replace *<password>* with the API password that you got when `first
  logging in`_, or create a new API passord by visiting
  `access.nrec.no`_ and clicking on "Reset API password"
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

Secure password alternatives
\\\\\\\\\\\\\\\\\\\\\\\\\\\\

If you do not want to enter your clear text password into a file, even when
secured as described above, there is the alternative of using the operating
systems keychain where available. The different OS', distributions and releases
implements a wide variety of keychains and tools. It is impossible to accurately
describe the necessary steps for all of those, so this is mainly left as an
excersise for our users. But below is two examples, and maybe one of these will
fit, or is close enough to enable you to set this up in your environment.


Mac OS
''''''

Run this command:

.. code-block:: console

  $ security add-generic-password -U -a ${USER} -D "environment variable" -s NREC_OPENSTACK_API_KEY -w “secret"

... and then replace the `OS_PASSWORD` line in the *keystone_rc.sh* file (line 3
in the template above) with:

.. code-block:: bash

  export OS_PASSWORD=$(security find-generic-password -w -a ${USER} -D "environment variable" -s NREC_OPENSTACK_API_KEY)


Linux
'''''

Install ``libsecret``/``libsecret-tools`` or whichever package provides the
`secret-tool` command.

Run this command:

.. code-block:: console

  $ secret-tool store --label="NREC_OPENSTACK_API_KEY" password NREC_OPENSTACK_API_KEY

... and then replace the `OS_PASSWORD` line in the *keystone_rc.sh* file (line 3
in the template above) with:

.. code-block:: bash

  export OS_PASSWORD=$(secret-tool lookup password NREC_OPENSTACK_API_KEY)


.. NOTE::
   This is just examples and may not be exactly correct in your specific
   environment. But it ought to be precise enough to enable you to get the
   specifics suitable for your environment.
