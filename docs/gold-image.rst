.. |date| date::

.. |ss| raw:: html

   <strike>

.. |se| raw:: html

   </strike>

NREC GOLD images
================

Last changed: |date|

.. contents::

The NREC Team provides prebuild images for user consumption. We try to include
popular Linux distributions as well as Windows images with an up to date
patch level and basic features needed for working in the cloud.

We provide the following GOLD images:

============================== ======== ================== ======== ============== =======================
GOLD image                     Family   Default user name  Boot FW  End of Life    Notes
============================== ======== ================== ======== ============== =======================
**Alma Linux 8**               RedHat   ``almalinux``      UEFI     May, 2029      Downstream RHEL [1]_
**CentOS 7**                   RedHat   ``centos``         BIOS     May, 2024      Downstream RHEL [1]_
|ss| CentOS 8 |se|             RedHat   ``centos``         BIOS     **Dec, 2021**  Downstream RHEL [1]_
**CentOS Stream 8**            RedHat   ``centos``         BIOS     May, 2024      Upstream RHEL [1]_
**Debian 9**                   Debian   ``debian``         BIOS     June, 2022     "Stretch" release
**Debian 10**                  Debian   ``debian``         BIOS     June, 2024     "Buster" release
**Debian 11**                  Debian   ``debian``         UEFI     June, 2026     "Bullseye" release
**Fedora 34**                  RedHat   ``fedora``         BIOS     May, 2022      
**UiO Managed RHEL 7**         RedHat   ``cloud-user``     BIOS     June, 2024     UiO users only [2]_
**UiO Managed RHEL 8**         RedHat   ``cloud-user``     BIOS     May, 2029      UiO users only [2]_
**Rocky Linux 8**              RedHat   ``rocky``          BIOS     May, 2029      Downstream RHEL [1]_
**Ubuntu 18.04 LTS**           Debian   ``ubuntu``         BIOS     April, 2023    
**Ubuntu 20.04 LTS**           Debian   ``ubuntu``         BIOS     April, 2025    
**Ubuntu 21.04**               Debian   ``ubuntu``         BIOS     Dec, 2022      
**Windows Server 2019 Std**    Windows  ``Admin``          BIOS     Jan, 2024      Activation in BGO only
============================== ======== ================== ======== ============== =======================

.. rubric:: Footnotes

.. [1] "Downstream RHEL" means that this is a binary compatible distribution build on Redhat Enterprise Linux
       (RHEL), trailing the release closely. "Upstream RHEL" means that this distribution is *ahead* of RHEL, so
       if RHEL is in 8.4 release, the Stream release will be somewhere near the future 8.5 RHEL release.

.. [2] FIXME
