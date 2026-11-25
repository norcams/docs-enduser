.. |ss| raw:: html

   <strike>

.. |se| raw:: html

   </strike>

NREC GOLD images
================

.. contents::

The NREC team provides pre‑built images that include popular Linux distributions and Windows images, kept up‑to‑date and equipped with the essential features for cloud workloads.

Available GOLD images
----------------------

Currently available GOLD images in NREC:

============================ ======== =========================== ========================== ===============
GOLD image                   Family   Default username            Boot firmware End of Life  Notes
============================ ======== =========================== ========================== ===============
**Alma Linux 8**             RedHat   ``almalinux``               UEFI                       May 2029
**Alma Linux 9**             RedHat   ``almalinux``               UEFI                       May 2032
**Alma Linux 10**            RedHat   ``almalinux``               UEFI                       May 2035
**CentOS Stream 9**          RedHat   ``cloud-user`` [#f1]_ UEFI  May 2027                   Upstream RHEL.
**CentOS Stream 10**         RedHat   ``cloud-user``              UEFI                       Expected 2030
**Fedora 44**                RedHat   ``fedora``                  UEFI                       May 2027
**Fedora 45**                RedHat   ``fedora``                  UEFI                       December 2027
**Rocky Linux 8**            RedHat   ``rocky``                   BIOS                       May 2029
**Rocky Linux 9**            RedHat   ``rocky``                   UEFI                       May 2032
**Rocky Linux 10**           RedHat   ``rocky``                   UEFI                       May 2035
**UiO Managed RHEL 8**       RedHat   ``cloud-user``              BIOS                       May 2029
**UiO Managed RHEL 9**       RedHat   ``cloud-user``              UEFI                       May 2032
**Debian 12**                Debian   ``debian``                  UEFI                       June 2028
**Debian 13**                Debian   ``debian``                  UEFI                       June 2030
**Ubuntu 22.04 LTS**         Debian   ``ubuntu``                  UEFI                       May 2027
**Ubuntu 24.04 LTS**         Debian   ``ubuntu``                  UEFI                       May 2029
**Ubuntu 26.04 LTS**         Debian   ``ubuntu``                  UEFI                       May 2031
**Windows Server 2022 Std**  Windows  ``Admin``                   UEFI                       October 2031
**Windows Server 2025 Std**  Windows  ``Admin``                   UEFI                       October 2034
============================ ======== =========================== ========================== ===============

In addition, the following GOLD images are available to GPU‑enabled users. These images have the correct GPU driver preinstalled:

========================== ======= ================= ========================== =========
GOLD image                 Family  Default username  Boot firmware End of Life  Notes
========================== ======= ================= ========================== =========
**vGPU Alma Linux 9**      RedHat  ``almalinux``     UEFI                       May 2032
**vGPU Alma Linux 10**     RedHat  ``almalinux``     UEFI                       May 2035
**vGPU Ubuntu 22.04 LTS**  Debian  ``ubuntu``        UEFI                       May 2027
**vGPU Ubuntu 24.04 LTS**  Debian  ``ubuntu``        UEFI                       May 2029
**vGPU Ubuntu 26.04 LTS**  Debian  ``ubuntu``        UEFI                       May 2031
========================== ======= ================= ========================== =========

.. NOTE::
   **Downstream RHEL:** A binary‑compatible distribution built from Red Hat Enterprise Linux, tracking the RHEL release closely.
   
   **Upstream RHEL:** A distribution that is ahead of the current RHEL release; e.g., CentOS Stream 9 aligns with the next RHEL 9.x series.

Retired GOLD images (no longer available)
------------------------------------------

The following GOLD images are retired and no longer available:

==================================================== ======= ================== =========================== ==============
GOLD image                                           Family  Default username   Boot firmware End of Life   Notes
==================================================== ======= ================== =========================== ==============
|ss| CentOS 7 |se|                                   RedHat  ``centos``         BIOS                        May 2024
|ss| CentOS 8 |se|                                   RedHat  ``centos``         BIOS                        Dec 2021
|ss| CentOS Stream 8 |se|                            RedHat  ``centos`` [#f2]_  BIOS                        May 2024
|ss| Fedora 34 |se|                                  RedHat  ``fedora``         BIOS                        May 2022
|ss| Fedora 35 |se|                                  RedHat  ``fedora``         BIOS                        November 2022
|ss| Fedora 36 |se|                                  RedHat  ``fedora``         BIOS                        June 2023
|ss| Fedora 37 |se|                                  RedHat  ``fedora``         UEFI                        December 2023
|ss| Fedora 38 |se|                                  RedHat  ``fedora``         UEFI                        May 2024
|ss| Fedora 39 |se|                                  RedHat  ``fedora``         UEFI                        Dec 2024
|ss| Fedora 40 |se|                                  RedHat  ``fedora``         UEFI                        May 2025
|ss| Fedora 41 |se|                                  RedHat  ``fedora``         UEFI                        Dec 2025
|ss| Fedora 42 |se|                                  RedHat  ``fedora``         UEFI                        May 2026
|ss| Fedora 43 |se|                                  RedHat  ``fedora``         UEFI                        December 2026
|ss| UiO Managed RHEL 7 |se|                         RedHat  ``cloud-user``     BIOS                        June 2024
|ss| Debian 9 |se|                                   Debian  ``debian``         BIOS                        June 2022
|ss| Debian 10 |se|                                  Debian  ``debian``         BIOS                        June 2024
|ss| Debian 11 |se|                                  Debian  ``debian``         UEFI                        August 2026
|ss| Ubuntu 18.04 LTS |se|                           Debian  ``ubuntu``         BIOS                        April 2023
|ss| Ubuntu 21.04 |se|                               Debian  ``ubuntu``         BIOS                        Dec 2021
|ss| Ubuntu 21.10 |se|                               Debian  ``ubuntu``         BIOS                        July 2022
|ss| Ubuntu 20.04 LTS |se|                           Debian  ``ubuntu``         BIOS                        April 2025
|ss| Windows Server 2019 Std |se| Windows ``Admin``  UEFI    January 2029       Licensed for BGO use only.
|ss| vGPU Alma Linux 8 |se|                          RedHat  ``almalinux``      UEFI                        May 2029
==================================================== ======= ================== =========================== ==============

UiO Managed
-----------

Projects that belong to an organization affiliated with UiO can use the “UiO Managed” images. An instance created from any of these images will be automatically managed by the UiO IT department, including CFEngine configuration management, monitoring, and related services.

Automatic updates
-----------------

Automatic package updates are enabled for all GOLD images. For Red Hat‑family Linux distributions this is implemented via a systemd timer that periodically runs a dnf‑based service. Debian‑family distributions use *unattended‑upgrades* with apt configuration, and Windows uses its own update mechanism.

.. [#f1] GOLD images for CentOS Stream 9 released between 1 July 2022 and 1 Nov 2022 used the default username ``centos``.
.. [#f2] CentOS Stream 8 images released before 1 Dec 2022 used the default username ``centos``. Between 1 Dec 2022 and 1 May 2023 the default was changed to ``cloud-user``.
.. [#f3] Earlier CentOS Stream 9 images booted via BIOS; UEFI became the default starting 1 Aug 2025.
