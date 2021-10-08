.. |date| date::

NREC GOLD images
================

Last changed: |date|

.. contents::

The NREC Team provides prebuild images for user consumption. We try to include
popular Linux distributions as well as Windows images with an up to date
patch level and basic features needed for working in the cloud.

We provide the following GOLD images:

============================== ======== ================== ============== =======================
GOLD image                     Family   Default user name  End of Life    Notes
============================== ======== ================== ============== =======================
**Alma Linux 8**               RedHat   ``almalinux``      May, 2029      Downstream RHEL*
**CentOS 7**                   RedHat   ``centos``         May, 2024      Downstream RHEL*
**CentOS 8**                   RedHat   ``centos``         **Dec, 2021**  Downstream RHEL*
**CentOS Stream 8**            RedHat   ``centos``         May, 2024      Upstream RHEL*
**Debian 9**                   Debian   ``debian``         June, 2022     "Stretch" release
**Debian 10**                  Debian   ``debian``         June, 2024     "Buster" release
**Debian 11**                  Debian   ``debian``         June, 2026     "Bullseye" release
**Fedora 34**                  RedHat   ``fedora``         May, 2022
**Redhat Enterprise Linux 8**  RedHat   ``cloud-user``     May, 2029      UiO users only
**Rocky Linux 8**              RedHat   ``rocky``          May, 2029      Downstream RHEL*
**Ubuntu 18.04 LTS**           Debian   ``ubuntu``         April, 2023
**Ubuntu 20.04 LTS**           Debian   ``ubuntu``         April, 2025
**Ubuntu 21.04**               Debian   ``ubuntu``         Dec, 2022
**Windows Server 2019 Std**    Windows  ``Admin``          Jan, 2024      Activation in BGO only
============================== ======== =================  ============== =======================

*) "Downstream RHEL" means that this is a binary compatible distribution build on Redhat Enterprise Linux
(RHEL), trailing the release closely. "Upstream RHEL" means that this distribution is ahead of RHEL, so
if RHEL is in 8.4 release, the Stream release will be somewhere near the future 8.5 RHEL release.
