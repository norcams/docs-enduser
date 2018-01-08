.. |date| date::

Speculative Execution Attacks
=============================

Last changed: |date|

.. contents::


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

With an infrastructure-as-a-service cloud like UH-IaaS, the customer
is responsible for the security of the instances running in his/her
project.  As the service provider, we will make available updated
images in which these speculative execution issues are mitigated.
However, the customer still needs to take action either by
reprovisioning the instances using the updated images, or by updating
the running images using the appropriate tools for the operating
system.


Updating CentOS
---------------

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


Updating Fedora
---------------

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


Updating Debian
---------------

In order to update an instance running Debian, perform the following:

#. Log in as user "debian":

   .. parsed-literal::

     $ **ssh debian@<instance-ip-address>**

#. Run "FIXME" using sudo:

   .. parsed-literal::

     $ **FIXME**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh debian@<instance-ip-address> 'uname -sr'**
     FIXME

   The output above shows the latest kernel for Debian FIXME as of January
   8, 2018.


Updating Ubuntu
---------------

In order to update an instance running Ubuntu, perform the following:

#. Log in as user "ubuntu":

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address>**

#. Run "FIXME" using sudo:

   .. parsed-literal::

     $ **FIXME**

#. Reboot the instance:

   .. parsed-literal::

     $ **sudo reboot**

#. Check that the running kernel has been updated:

   .. parsed-literal::

     $ **ssh ubuntu@<instance-ip-address> 'uname -sr'**
     FIXME

   The output above shows the latest kernel for Ubuntu FIXME as of January
   8, 2018.


Additional References
---------------------

.. _[Red Hat] Kernel Side-Channel Attacks - CVE-2017-5754 CVE-2017-5753 CVE-2017-5715: https://access.redhat.com/security/vulnerabilities/speculativeexecution
.. _[Google Project Zero] Reading privileged memory with a side-channel: https://googleprojectzero.blogspot.ca/2018/01/reading-privileged-memory-with-side.html
.. _Meltdown and Spectre main site: https://meltdownattack.com/
.. _[Red Hat] Controlling the Performance Impact of Microcode and Security Patches for CVE-2017-5754 CVE-2017-5715 and CVE-2017-5753 using Red Hat Enterprise Linux Tunables: https://access.redhat.com/articles/3311301

* `[Red Hat] Kernel Side-Channel Attacks - CVE-2017-5754 CVE-2017-5753
  CVE-2017-5715`_

* `[Google Project Zero] Reading privileged memory with a
  side-channel`_

* `[Red Hat] Controlling the Performance Impact of Microcode and
  Security Patches for CVE-2017-5754 CVE-2017-5715 and CVE-2017-5753
  using Red Hat Enterprise Linux Tunables`_

* `Meltdown and Spectre main site`_

