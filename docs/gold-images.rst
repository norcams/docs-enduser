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
**Alma Linux 10**              RedHat   ``almalinux``         UEFI     May, 2035            Downstream RHEL [#f1]_
**CentOS Stream 9**            RedHat   ``cloud-user`` [#f3]_ BIOS     May, 2027            Upstream RHEL [#f2]_
**CentOS Stream 10**           RedHat   ``cloud-user``        UEFI     Expected 2030        Upstream RHEL [#f2]_
**Debian 11**                  Debian   ``debian``            UEFI     June, 2026           "Bullseye" release
**Debian 12**                  Debian   ``debian``            UEFI     June, 2028           "Bookworm" release
**Fedora 41**                  RedHat   ``fedora``            UEFI     Dec, 2025
**Fedora 42**                  RedHat   ``fedora``            UEFI     June, 2026
**UiO Managed RHEL 8**         RedHat   ``cloud-user``        BIOS     May, 2029            UiO projects only
**UiO Managed RHEL 9**         RedHat   ``cloud-user``        UEFI     May, 2032            UiO projects only
**Rocky Linux 8**              RedHat   ``rocky``             BIOS     May, 2029            Downstream RHEL [#f1]_
**Rocky Linux 9**              RedHat   ``rocky``             UEFI     May, 2032            Downstream RHEL [#f1]_
**Rocky Linux 10**             RedHat   ``rocky``             UEFI     May, 2035            Downstream RHEL [#f1]_
**Ubuntu 22.04 LTS**           Debian   ``ubuntu``            UEFI     April, 2027          "Jammy Jellyfish"
**Ubuntu 24.04 LTS**           Debian   ``ubuntu``            UEFI     April, 2029          "Noble Numbat"
**Windows Server 2022 Std**    Windows  ``Admin``             UEFI     October, 2031        Licensed in BGO only
**Windows Server 2025 Std**    Windows  ``Admin``             UEFI     October, 2034        Licensed in BGO only
============================== ======== ===================== ======== ==================== =======================

In addition, the following GOLD images are available to GPU
users. These images have the correct GPU driver preinstalled:

============================== ======== ===================== ======== ==================== =======================
GOLD image                     Family   Default user name     Boot FW  End of Life          Notes
============================== ======== ===================== ======== ==================== =======================
**vGPU Alma Linux 8**          RedHat   ``almalinux``         UEFI     May, 2029            Downstream RHEL [#f1]_
**vGPU Alma Linux 9**          RedHat   ``almalinux``         UEFI     May, 2032            Downstream RHEL [#f1]_
**vGPU Alma Linux 10**         RedHat   ``almalinux``         UEFI     May, 2035            Downstream RHEL [#f1]_
**vGPU Ubuntu 22.04 LTS**      Debian   ``ubuntu``            UEFI     April, 2027          "Jammy Jellyfish"
**vGPU Ubuntu 24.04 LTS**      Debian   ``ubuntu``            UEFI     April, 2029          "Noble Numbat"
============================== ======== ===================== ======== ==================== =======================

.. [#f1] "Downstream RHEL" means that this is a binary compatible
   distribution built from Red Hat Enterprise Linux (RHEL), trailing
   the release closely.

.. [#f2] "Upstream RHEL" means that this distribution
   is *ahead* of RHEL, so if RHEL is in 9.n release, the Stream
   release will be somewhere near the future 9.n+1 RHEL release.

.. [#f3] GOLD images for CentOS Stream 9 released in the period
   between July 1, 2022 and November 1, 2022 had their default
   username set to "centos".

.. [#f4] GOLD images for CentOS Stream 8 released before December 1,
   2022 had their default username set to "centos". Between December 1
   and May 1, 2023 the default username was set to "cloud-user".


Retired GOLD images
-------------------

The following GOLD images are retired and no longer available:

================================= ======== ================== ======== ==================== =======================
GOLD image                        Family   Default user name  Boot FW  End of Life          Notes
================================= ======== ================== ======== ==================== =======================
|ss| CentOS 7 |se|                RedHat   ``centos``         BIOS     May, 2024            Downstream RHEL [#f1]_
|ss| CentOS 8 |se|                RedHat   ``centos``         BIOS     Dec, 2021            Downstream RHEL [#f1]_
|ss| CentOS Stream 8 |se|         RedHat   ``centos`` [#f4]_  BIOS     May, 2024            Upstream RHEL [#f2]_
|ss| Fedora 34 |se|               RedHat   ``fedora``         BIOS     May, 2022
|ss| Fedora 35 |se|               RedHat   ``fedora``         BIOS     November, 2022
|ss| Fedora 36 |se|               RedHat   ``fedora``         BIOS     June, 2023
|ss| Fedora 37 |se|               RedHat   ``fedora``         UEFI     December, 2023
|ss| Fedora 38 |se|               RedHat   ``fedora``         UEFI     May, 2024
|ss| Fedora 39 |se|               RedHat   ``fedora``         UEFI     Dec, 2024
|ss| Fedora 40 |se|               RedHat   ``fedora``         UEFI     May, 2025
|ss| Ubuntu 18.04 LTS |se|        Debian   ``ubuntu``         BIOS     April, 2023
|ss| Ubuntu 21.04 |se|            Debian   ``ubuntu``         BIOS     Dec, 2021
|ss| Ubuntu 21.10 |se|            Debian   ``ubuntu``         BIOS     July, 2022
|ss| Ubuntu 20.04 LTS |se|        Debian   ``ubuntu``         BIOS     April, 2025          "Focal Fossa"
|ss| Debian 9 |se|                Debian   ``debian``         BIOS     June, 2022           "Stretch" release
|ss| Debian 10 |se|               Debian   ``debian``         BIOS     June, 2024           "Buster" release
|ss| UiO Managed RHEL 7 |se|      RedHat   ``cloud-user``     BIOS     June, 2024           UiO projects only
|ss| Windows Server 2019 Std |se| Windows  ``Admin``          UEFI     January, 2029        Licensed in BGO only
================================= ======== ================== ======== ==================== =======================


UiO Managed
-----------

Shared projects with an organization affiliation to UiO have access to
the "UiO Managed" images. An instance created from any of these images
will instantly be automatically managed by the IT department at
UiO. This includes CFEngine configuration management, monitoring and
everything else.

Automatic updates
-----------------

Automatic updates are enabled for all GOLD images. This involves
automatic download and update of packages. The specific configuration
depends on the Linux distribution and Windows version. For Linux
distributions in the RedHat family, it involves enabling and starting
a systemd timer, which regurarly calls a systemd service that reads
from a dnf configuration file, while for distributions in the Debian
family, the same effect is achieved with unattended-upgrades and apt
configuration. For Windows, the configuration varies.
