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

============================== ======== ====================== ============= ==================== ===============================
GOLD image                     Family   Default username       Boot firmware End of Life          Notes
============================== ======== ====================== ============= ==================== ===============================
**Alma Linux 8**               RedHat   ``almalinux``          UEFI          May 2029            Downstream RHEL.
**Alma Linux 9**               RedHat   ``almalinux``          UEFI          May 2032            Downstream RHEL.
**Alma Linux 10**              RedHat   ``almalinux``          UEFI          May 2035            Downstream RHEL.
**CentOS Stream 9**            RedHat   ``cloud-user`` [#f1]_ UEFI          May 2027            Upstream RHEL.
**CentOS Stream 10**           RedHat   ``cloud-user``         UEFI          Expected 2030       Upstream RHEL.
**Fedora 44**                  RedHat   ``fedora``             UEFI          May 2027            
**Fedora 45**                  RedHat   ``fedora``             UEFI          December 2027       
**Rocky Linux 8**              RedHat   ``rocky``              BIOS          May 2029            Downstream RHEL.
**Rocky Linux 9**              RedHat   ``rocky``              UEFI          May 2032            Downstream RHEL.
**Rocky Linux 10**             RedHat   ``rocky``              UEFI          May 2035            Downstream RHEL.
**UiO Managed RHEL 8**         RedHat   ``cloud-user``         BIOS          May 2029            UiO projects only.
**UiO Managed RHEL 9**         RedHat   ``cloud-user``         UEFI          May 2032            UiO projects only.
**Debian 12**                  Debian   ``debian``             UEFI          June 2028           Code name: "Bookworm".
**Debian 13**                  Debian   ``debian``             UEFI          June 2030           Code name: "Trixie".
**Ubuntu 22.04 LTS**           Debian   ``ubuntu``             UEFI          May 2027            Code name: "Jammy Jellyfish".
**Ubuntu 24.04 LTS**           Debian   ``ubuntu``             UEFI          May 2029            Code name: "Noble Numbat".
**Ubuntu 26.04 LTS**           Debian   ``ubuntu``             UEFI          May 2031            Code name: "Resolute Raccoon".
**Windows Server 2022 Std**    Windows  ``Admin``              UEFI          October 2031        Licensed for BGO use only.
**Windows Server 2025 Std**    Windows  ``Admin``              UEFI          October 2034        Licensed for BGO use only.
============================== ======== ====================== ============= ==================== ===============================

In addition, the following GOLD images are available to GPU‑enabled users. These images have the correct GPU driver preinstalled:

============================== ======== ====================== ============= ==================== ===============================
GOLD image                     Family   Default username       Boot firmware End of Life          Notes
============================== ======== ====================== ============= ==================== ===============================
**vGPU Alma Linux 9**          RedHat   ``almalinux``          UEFI          May 2032            Downstream RHEL.
**vGPU Alma Linux 10**         RedHat   ``almalinux``          UEFI          May 2035            Downstream RHEL.
**vGPU Ubuntu 22.04 LTS**      Debian   ``ubuntu``             UEFI          May 2027            Code name: "Jammy Jellyfish".
**vGPU Ubuntu 24.04 LTS**      Debian   ``ubuntu``             UEFI          May 2029            Code name: "Noble Numbat".
**vGPU Ubuntu 26.04 LTS**      Debian   ``ubuntu``             UEFI          May 2031            Code name: "Resolute Raccoon".
============================== ======== ====================== ============= ==================== ===============================

.. NOTE::
   **Downstream RHEL:** A binary‑compatible distribution built from Red Hat Enterprise Linux, tracking the RHEL release closely.
   
   **Upstream RHEL:** A distribution that is ahead of the current RHEL release; e.g., CentOS Stream 9 aligns with the next RHEL 9.x series.

Retired GOLD images (no longer available)
------------------------------------------

The following GOLD images are retired and no longer available:

============================== ======== ====================== ============= ==================== ===============================
GOLD image                     Family   Default username       Boot firmware End of Life          Notes
============================== ======== ====================== ============= ==================== ===============================
|ss| CentOS 7 |se|            RedHat   ``centos``             BIOS          May 2024            Downstream RHEL.
|ss| CentOS 8 |se|            RedHat   ``centos``             BIOS          Dec 2021            Downstream RHEL.
|ss| CentOS Stream 8 |se|     RedHat   ``centos`` [#f2]_    BIOS          May 2024            Upstream RHEL.
|ss| Fedora 34 |se|           RedHat   ``fedora``             BIOS          May 2022            
|ss| Fedora 35 |se|           RedHat   ``fedora``             BIOS          November 2022       
|ss| Fedora 36 |se|           RedHat   ``fedora``             BIOS          June 2023           
|ss| Fedora 37 |se|           RedHat   ``fedora``             UEFI          December 2023       
|ss| Fedora 38 |se|           RedHat   ``fedora``             UEFI          May 2024            
|ss| Fedora 39 |se|           RedHat   ``fedora``             UEFI          Dec 2024            
|ss| Fedora 40 |se|           RedHat   ``fedora``             UEFI          May 2025            
|ss| Fedora 41 |se|           RedHat   ``fedora``             UEFI          Dec 2025            
|ss| Fedora 42 |se|           RedHat   ``fedora``             UEFI          May 2026            
|ss| Fedora 43 |se|           RedHat   ``fedora``             UEFI          December 2026       
|ss| UiO Managed RHEL 7 |se|  RedHat   ``cloud-user``         BIOS          June 2024           UiO projects only.
|ss| Debian 9 |se|            Debian   ``debian``             BIOS          June 2022           Code name: "Stretch".
|ss| Debian 10 |se|           Debian   ``debian``             BIOS          June 2024           Code name: "Buster".
|ss| Debian 11 |se|           Debian   ``debian``             UEFI          August 2026         Code name: "Bullseye".
|ss| Ubuntu 18.04 LTS |se|    Debian   ``ubuntu``             BIOS          April 2023          Code name: "Bionic Beaver".
|ss| Ubuntu 21.04 |se|        Debian   ``ubuntu``             BIOS          Dec 2021            Code name: "Hirsute Hippo".
|ss| Ubuntu 21.10 |se|        Debian   ``ubuntu``             BIOS          July 2022           Code name: "Impish Indri".
|ss| Ubuntu 20.04 LTS |se|    Debian   ``ubuntu``             BIOS          April 2025          Code name: "Focal Fossa".
|ss| Windows Server 2019 Std |se| Windows ``Admin``          UEFI          January 2029        Licensed for BGO use only.
|ss| vGPU Alma Linux 8 |se|   RedHat   ``almalinux``          UEFI          May 2029            Downstream RHEL.
============================== ======== ====================== ============= ==================== ===============================

UiO Managed
-----------

Projects that belong to an organization affiliated with UiO can use the “UiO Managed” images. An instance created from any of these images will be automatically managed by the UiO IT department, including CFEngine configuration management, monitoring, and related services.

Automatic updates
-----------------

Automatic package updates are enabled for all GOLD images. For Red Hat‑family Linux distributions this is implemented via a systemd timer that periodically runs a dnf‑based service. Debian‑family distributions use *unattended‑upgrades* with apt configuration, and Windows uses its own update mechanism.

.. [#f1] GOLD images for CentOS Stream 9 released between 1 July 2022 and 1 Nov 2022 used the default username ``centos``.
.. [#f2] CentOS Stream 8 images released before 1 Dec 2022 used the default username ``centos``. Between 1 Dec 2022 and 1 May 2023 the default was changed to ``cloud-user``.
.. [#f3] Earlier CentOS Stream 9 images booted via BIOS; UEFI became the default starting 1 Aug 2025.
