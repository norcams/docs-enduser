Speculative Execution Attacks
=============================

Last changed: 2018-01-10

.. IMPORTANT::
   **UPDATE 2018-01-10**
   Kernel patches for Ubuntu 16.04 LTS and 17.10 are now available. See
   instructions below.  New instances will have the updated kernel.

   **UPDATE 2018-01-09**
   Contrary to what's been said in this security advisory earlier, a kernel patch
   for Ubuntu is not yet available, however, it is expected by January 9, 2018.
   We're sorry to have provided misleading information and will notitfy our users
   when a patch is available.

.. contents::

.. highlight:: none

Background Information
----------------------

In January 2018, multiple microarchitectural (hardware) implementation
issues surfaced, affecting many modern microprocessors.  These issues
require updates to the operating system (e.g. Linux/Windows kernel)
and/or in combination with a microcode update.  An unprivileged
attacker can use these flaws to bypass conventional memory security
restrictions in order to gain read access to privileged memory that
would otherwise be inaccessible. There are 3 known CVEs related to
this issue in combination with Intel, AMD, and ARM architectures.

With an infrastructure-as-a-service cloud like NREC, the customer
is responsible for the security of the instances running in his/her
project.  As the service provider, we will make available updated
images in which these speculative execution issues are mitigated.
However, the customer still needs to take action either by
reprovisioning the instances using the updated images, or by updating
any running instances using the appropriate tools for the operating
system.

For more information regarding these security issues, refer to
`Additional References`_.


Updating your Instances
-----------------------

This paragraph describes in detail how to update any of the standard
Linux distributions offered in NREC.

CentOS
~~~~~~

In order to update an instance running CentOS, perform the following:

#. Log in as user "centos":

   .. parsed-literal::

     $ **ssh centos@<instance-ip-address>**

#. Run "yum upgrade" using sudo:

   .. parsed-literal::

     $ **sudo yum upgrade**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh centos@<instance-ip-address> 'uname -sr'**
     Linux 3.10.0-693.11.6.el7.x86_64

   The output above shows the latest kernel for CentOS 7 as of January
   8, 2018.


Fedora
~~~~~~

In order to update an instance running Fedora, perform the following:

#. Log in as user "fedora":

   .. parsed-literal::

     $ **ssh fedora@<instance-ip-address>**

#. Run "dnf upgrade" using sudo:

   .. parsed-literal::

     $ **sudo dnf upgrade --refresh**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh fedora@<instance-ip-address> 'uname -sr'**
     Linux 4.14.11-300.fc27.x86_64

   The output above shows the latest kernel for Fedora 27 as of January
   8, 2018.


Debian
~~~~~~

In order to update an instance running Debian, perform the following:

#. Log in as user "debian":

   .. parsed-literal::

     $ **ssh debian@<instance-ip-address>**

#. Update and upgrade using sudo:

   .. parsed-literal::

     $ **sudo apt-get update && sudo apt-get -y dist-upgrade**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh debian@<instance-ip-address> 'uname -srv'**
     Linux 4.9.0-5-amd64 #1 SMP Debian 4.9.65-3+deb9u2 (2018-01-04)

   The output above shows the latest kernel for Debian 9 as of January
   8, 2018.


Ubuntu
~~~~~~

Ubuntu Cloud images are preinstalled with Unattended Upgrades meaning security
updates will be automacially installed when they're available.  However, you
need to reboot your instances in order to actually run the updated kernel.

#. Check your kernel version

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address> 'uname -srv'**

   You should get the following output if you have the updated kernel in 16.04
   LTS:

   .. parsed-literal::

     Linux 4.4.0-108-generic #131-Ubuntu SMP Sun Jan 7 14:34:49 UTC 2018

   or in Ubuntu 17.10:

   .. parsed-literal::

     Linux 4.13.0-25-generic #29-Ubuntu SMP Mon Jan 8 21:14:41 UTC 2018

#. If the output shows something else, check the unattended upgrades log:

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address>**
     $ **less /var/log/unattended-upgrades/unattended-upgrades.log**

   and look for a line similar to this:

   .. parsed-literal::

     2018-01-10 09:25:25,440 INFO Packages that will be upgraded: linux-headers-generic linux-headers-virtual linux-image-virtual linux-virtual

#. If you have something that looks like the above, reboot your instance and
   check your kernel version again

   .. parsed-literal::

     $ **sudo reboot**

#. If you don't, or if you've disabled or uninstalled Unattended Upgrades for
   some reason, proceed with manual updating shown bellow.

In order to manually update an instance running Ubuntu, perform the following:

#. Log in as user "ubuntu":

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address>**

#. Update and upgrade using sudo:

   .. parsed-literal::

     $ **sudo apt-get update && sudo apt-get -y dist-upgrade**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address> 'uname -srv'**
     Linux 4.4.0-108-generic #131-Ubuntu SMP Sun Jan 7 14:34:49 UTC 2018

   if you're running 16.04 LTS or

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address> 'uname -srv'**
     Linux 4.13.0-25-generic #29-Ubuntu SMP Mon Jan 8 21:14:41 UTC 2018

   if you're running 17.10.

   The output above shows the latest kernel for Ubuntu 16.04 LTS and 17.10 as
   of January 10, 2018.

Additional References
---------------------

.. _[Red Hat] Kernel Side-Channel Attacks - CVE-2017-5754 CVE-2017-5753 CVE-2017-5715: https://access.redhat.com/security/vulnerabilities/speculativeexecution
.. _[Google Project Zero] Reading privileged memory with a side-channel: https://googleprojectzero.blogspot.ca/2018/01/reading-privileged-memory-with-side.html
.. _Meltdown and Spectre main site: https://meltdownattack.com/
.. _[Red Hat] Controlling the Performance Impact of Microcode and Security Patches for CVE-2017-5754 CVE-2017-5715 and CVE-2017-5753 using Red Hat Enterprise Linux Tunables: https://access.redhat.com/articles/3311301
.. _[Red Hat] Speculative Execution Exploit Performance Impacts: https://access.redhat.com/articles/3307751
.. _[Microsoft] Understanding the performance impact of Spectre and Meltdown mitigations on Windows Systems: https://cloudblogs.microsoft.com/microsoftsecure/2018/01/09/understanding-the-performance-impact-of-spectre-and-meltdown-mitigations-on-windows-systems/

* `[Red Hat] Kernel Side-Channel Attacks - CVE-2017-5754 CVE-2017-5753
  CVE-2017-5715`_

* `[Google Project Zero] Reading privileged memory with a
  side-channel`_

* `[Red Hat] Speculative Execution Exploit Performance Impacts`_

* `[Red Hat] Controlling the Performance Impact of Microcode and
  Security Patches for CVE-2017-5754 CVE-2017-5715 and CVE-2017-5753
  using Red Hat Enterprise Linux Tunables`_

* `[Microsoft] Understanding the performance impact of Spectre and
  Meltdown mitigations on Windows Systems`_

* `Meltdown and Spectre main site`_

