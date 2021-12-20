Migrate instances from CentOS 8
===============================

.. Important:
   WIP!
   This is Work-In-Progress
   WIP!


Last changed: 2021-12-20


CentOS 8 is in its final days and have End-Of-Life January 31th 2022. Those
running an instance based on an CentOS 8 image (like one of our previous GOLD offerings)
MUST migrate to a supported distribution before the cut-off date! This
requirement is set to ensure a supported instance which continues to receive all
relevant important security fixes etc. To help those users in this, we have
compiled this list of possible migration strategies.


.. Important:
   NREC does not take any responsibility for any loss or corruption following
   these guidelines! This documentation are just presented as a servide to our
   users, and we recommend reading up on the issue yourself before attempting
   any migration.


AlmaLinux
---------

:Official website: https://almalinux.org/
:EOL (AlmaLinux 8): May, 2029
:Official blurb:
  AlmaLinux OS is an open-source, community-driven Linux operating system that
  fills the gap left by the discontinuation of the CentOS Linux stable release.
  AlmaLinux OS is a 1:1 binary compatible fork of RHEL® guided and built by the
  community.

**AlmaLinux** is designed as a direct replacement for CentOS as it has been up
until now. That is; it directly reflects offical *RHEL* of the same generation.


Migrate from CentOS 8 to AlmaLinux 8
''''''''''''''''''''''''''''''''''''

1. Download migrate script from AlmaLinux GitHub account:

.. code-block:: console

  $ curl -O https://raw.githubusercontent.com/AlmaLinux/almalinux-deploy/master/almalinux-deploy.sh

2. Set executable bit:

.. code-block:: console

  $ chmod +x almalinux-deploy.sh

3. Run migrate script:

.. code-block:: console

  $ sudo ./almalinux-deploy.sh

  This step will take some time while it validate that your system is ready
  for migration, uninstall some CentOS specific repositories and packets, enables
  AlmaLinux and upgrades the system to level with current state.

4. Reboot:

.. code-block:: console

  $ sudo reboot


That's it! Enjoy a supported version of AlmaLinux!


.. Important:
   As always when downloading scripts/code from Internet: Please review the
   script before executing it! Validate that is not doing anything malicious!


Rocky Linux
-----------

:Official website: https://rockylinux.org/
:EOL (Rocky Linux 8): May, 2029
:Official blurb:
  Rocky Linux is an open-source enterprise operating system designed to be 100%
  bug-for-bug compatible with Red Hat Enterprise Linux®. It is under intensive
  development by the community.

**Rocky Linux** is, as AlmaLinux is, designed as a direct replacement for CentOS as it has been up
until now.


Migrate from CentOS 8 to Rocky Linux 8
''''''''''''''''''''''''''''''''''''''

1. Download migrate script from Rocky Linux GitHub account:

.. code-block:: console

  $ curl https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh -o migrate2rocky.sh


2. Set executable bit:

.. code-block:: console

  $ chmod +x migrate2rocky.sh

3. Run migrate script:

.. code-block:: console

  $ sudo ./migrate2rocky.sh -r

  This step will take some time while validating, removing and
  installing/updating packages and repositories.

4. Reboot:

.. code-block:: console

  $ sudo reboot


That's it! Enjoy a supported version of Rocky Linux!


.. Important:
   As always when downloading scripts/code from Internet: Please review the
   script before executing it! Validate that is not doing anything malicious!


CentOS Stream 8
---------------

:Official website: https://www.centos.org/
:EOL (CentOS Stream 8): May, 2024
:Official blurb:
  CentOS Stream, on the other hand, is the upstream, public development branch
  for RHEL. Specifically, CentOS Stream 8 is the upstream for the next minor
  release of RHEL 8, CentOS Stream 9 for the next minor release of RHEL 9, and so
  on.

**CentOS Stream** differs from the other distributions mentioned previously, as
it is an ``upstream`` release! It sits between *Fedora* (which is released using
versioning) and *RHEL*. CentOS Stream continously receives content planned for
RHEL as it is ready, whereas RHEL might not get it until next minor release.


Migrate from CentOS 8 to CentOS Stream 8
''''''''''''''''''''''''''''''''''''''''

1. Update the current system:

.. code-block:: console

   $ sudo dnf update

2. After updating the system, reboot it:

.. code-block:: console

   $ sudo reboot

3. Enable CentOS Stream repository:

.. code-block:: console

  $ sudo dnf install centos-release-stream

4. Replace all existing CentOS Linux repositories with CentOS Stream repositories:

.. code-block:: console

  $ sudo dnf swap centos-{linux,stream}-repos

5. Apply the migration proper:

.. code-block:: console

  $ sudo dnf distro-sync

  Answer 'Y' if prompted.

6. Reboot:

.. code-block:: console

  $ sudo reboot

