.. |ss| raw:: html

   <strike>

.. |se| raw:: html

   </strike>

NREC GOLD images
================

.. contents::

The NREC Team provides prebuilt images for user consumption. We try to include
popular Linux distributions as well as Windows images with an up to date
patch level and basic features needed for working in the cloud.


Current GOLD images
-------------------

Currently available GOLD images in NREC:

============================== ======== ===================== ======== ==================== =======================
GOLD image                     Family   Default user name     Boot FW  End of Life          Notes
============================== ======== ===================== ======== ==================== =======================
**Alma Linux 8**               RedHat   ``almalinux``         UEFI     May, 2029            Downstream RHEL [#f1]_
**Alma Linux 9**               RedHat   ``almalinux``         UEFI     May, 2032            Downstream RHEL [#f1]_
**CentOS 7**                   RedHat   ``centos``            BIOS     May, 2024            Downstream RHEL [#f1]_
**CentOS Stream 8**            RedHat   ``cloud-user`` [#f3]_ BIOS     May, 2024            Upstream RHEL [#f1]_
**CentOS Stream 9**            RedHat   ``cloud-user`` [#f2]_ BIOS     *unknown*            Upstream RHEL [#f1]_
**Debian 10**                  Debian   ``debian``            BIOS     June, 2024           "Buster" release
**Debian 11**                  Debian   ``debian``            UEFI     June, 2026           "Bullseye" release
**Fedora 37**                  RedHat   ``fedora``            UEFI     July, 2024
**UiO Managed RHEL 7**         RedHat   ``cloud-user``        BIOS     June 2024            UiO projects only
**UiO Managed RHEL 8**         RedHat   ``cloud-user``        BIOS     May, 2029            UiO projects only
**UiO Managed RHEL 9**         RedHat   ``cloud-user``        UEFI     May, 2032            UiO projects only
**Rocky Linux 8**              RedHat   ``rocky``             BIOS     May, 2029            Downstream RHEL [#f1]_
**Rocky Linux 9**              RedHat   ``rocky``             UEFI     May, 2032            Downstream RHEL [#f1]_
**Ubuntu 20.04 LTS**           Debian   ``ubuntu``            BIOS     April, 2025
**Ubuntu 22.04 LTS**           Debian   ``ubuntu``            UEFI     April, 2027
**Windows Server 2019 Std**    Windows  ``Admin``             BIOS     Janary, 2024         Activation in BGO only
============================== ======== ===================== ======== ==================== =======================

In addition, the following GOLD images are available to GPU
users. These images have the correct GPU driver preinstalled:

============================== ======== ===================== ======== ==================== =======================
GOLD image                     Family   Default user name     Boot FW  End of Life          Notes
============================== ======== ===================== ======== ==================== =======================
**vGPU Alma Linux 8**          RedHat   ``almalinux``         UEFI     May, 2029            Downstream RHEL [#f1]_
**vGPU Alma Linux 9**          RedHat   ``almalinux``         UEFI     May, 2032            Downstream RHEL [#f1]_
**vGPU Ubuntu 20.04 LTS**      Debian   ``ubuntu``            BIOS     April, 2025
**vGPU Ubuntu 22.04 LTS**      Debian   ``ubuntu``            UEFI     April, 2027
============================== ======== ===================== ======== ==================== =======================

.. [#f1] "Downstream RHEL" means that this is a binary compatible
   distribution build on Red Hat Enterprise Linux (RHEL), trailing the
   release closely. "Upstream RHEL" means that this distribution
   is *ahead* of RHEL, so if RHEL is in 8.n release, the Stream
   release will be somewhere near the future 8.n+1 RHEL release.

.. [#f2] GOLD images for CentOS Stream 9 released in the period
   between July 1, 2022 and November 1, 2022 had their default
   username set to "centos".

.. [#f3] GOLD images for CentOS Stream 8 released before December 1,
   2022 had their default username set to "centos".


Retired GOLD images
-------------------

The following GOLD images are retired and no longer available:

============================== ======== ================== ======== ==================== =======================
GOLD image                     Family   Default user name  Boot FW  End of Life          Notes
============================== ======== ================== ======== ==================== =======================
|ss| CentOS 8 |se|             RedHat   ``centos``         BIOS     Dec, 2021            Downstream RHEL
|ss| Fedora 34 |se|            RedHat   ``fedora``         BIOS     May, 2022
|ss| Fedora 35 |se|            RedHat   ``fedora``         BIOS     November, 2022
|ss| Fedora 36 |se|            RedHat   ``fedora``         BIOS     June, 2023
|ss| Ubuntu 18.04 LTS |se|     Debian   ``ubuntu``         BIOS     April, 2023
|ss| Ubuntu 21.04 |se|         Debian   ``ubuntu``         BIOS     Dec, 2021
|ss| Ubuntu 21.10 |se|         Debian   ``ubuntu``         BIOS     July, 2022
|ss| Debian 9 |se|             Debian   ``debian``         BIOS     June, 2022           "Stretch" release
============================== ======== ================== ======== ==================== =======================


UiO Managed
-----------

Shared projects with an organization affiliation to UiO have access to
the "UiO Managed" images. An instance created from any of these images
will instantly be automatically managed by the IT department at
UiO. This includes CFEngine configuration management, monitoring and
everything else.
