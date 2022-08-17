.. |date| date::

.. |ss| raw:: html

   <strike>

.. |se| raw:: html

   </strike>

NREC GOLD images
================

Last changed: |date|

.. contents::

The NREC Team provides prebuilt images for user consumption. We try to include
popular Linux distributions as well as Windows images with an up to date
patch level and basic features needed for working in the cloud.

**Current GOLD images:**

============================== ======== ================== ======== ==================== =======================
GOLD image                     Family   Default user name  Boot FW  End of Life          Notes
============================== ======== ================== ======== ==================== =======================
**Alma Linux 8**               RedHat   ``almalinux``      UEFI     May, 2029            Downstream RHEL *
**Alma Linux 9**               RedHat   ``almalinux``      UEFI     May, 2032            Downstream RHEL *
**CentOS 7**                   RedHat   ``centos``         BIOS     May, 2024            Downstream RHEL *
**CentOS Stream 8**            RedHat   ``centos``         BIOS     May, 2024            Upstream RHEL *
**CentOS Stream 9**            RedHat   ``centos`` **      BIOS     *unknown*            Upstream RHEL *
**Debian 10**                  Debian   ``debian``         BIOS     June, 2024           "Buster" release
**Debian 11**                  Debian   ``debian``         UEFI     June, 2026           "Bullseye" release
**Fedora 36**                  RedHat   ``fedora``         BIOS     June, 2023
**UiO Managed RHEL 7**         RedHat   ``cloud-user``     BIOS     June 2024            UiO projects only
**UiO Managed RHEL 8**         RedHat   ``cloud-user``     BIOS     May, 2029            UiO projects only
**UiO Managed RHEL 9**         RedHat   ``cloud-user``     UEFI     May, 2032            UiO projects only
**Rocky Linux 8**              RedHat   ``rocky``          BIOS     May, 2029            Downstream RHEL *
**Rocky Linux 9**              RedHat   ``rocky``          UEFI     May, 2032            Downstream RHEL *
**Ubuntu 18.04 LTS**           Debian   ``ubuntu``         BIOS     April, 2023
**Ubuntu 20.04 LTS**           Debian   ``ubuntu``         BIOS     April, 2025
**Ubuntu 22.04 LTS**           Debian   ``ubuntu``         BIOS     April, 2032
**Windows Server 2019 Std**    Windows  ``Admin``          BIOS     Janary, 2024         Activation in BGO only
============================== ======== ================== ======== ==================== =======================

**Retired GOLD images:**

============================== ======== ================== ======== ==================== =======================
GOLD image                     Family   Default user name  Boot FW  End of Life          Notes
============================== ======== ================== ======== ==================== =======================
|ss| CentOS 8 |se|             RedHat   ``centos``         BIOS     Dec, 2021            Downstream RHEL *
|ss| Fedora 34 |se|            RedHat   ``fedora``         BIOS     May, 2022
|ss| Fedora 35 |se|            RedHat   ``fedora``         BIOS     November, 2022
|ss| Ubuntu 21.04 |se|         Debian   ``ubuntu``         BIOS     Dec, 2021
|ss| Ubuntu 21.10 |se|         Debian   ``ubuntu``         BIOS     July, 2022
|ss| Debian 9 |se|             Debian   ``debian``         BIOS     June, 2022           "Stretch" release
============================== ======== ================== ======== ==================== =======================


``*``
  "Downstream RHEL" means that this is a binary compatible
  distribution build on Redhat Enterprise Linux (RHEL), trailing the
  release closely. "Upstream RHEL" means that this distribution
  is *ahead* of RHEL, so if RHEL is in 8.*n* release, the Stream release
  will be somewhere near the future 8.*n+1* RHEL release.

``**``
  Prior to GOLD images released after July 1, 2022 the default
  username for CentOS Stream 9 was "cloud-user"


UiO Managed
-----------

Shared projects with an organization affiliation to UiO have access to
the "UiO Managed" images. An instance created from any of these images
will instantly be automatically managed by the IT department at
UiO. This includes CFEngine configuration management, monitoring and
everything else.
