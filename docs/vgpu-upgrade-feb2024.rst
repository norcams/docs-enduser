vGPU Upgrade February 2024
==========================

Last changed: 2024-02-08

.. contents::


Background
----------

Currently, the vGPU service is NREC is using NVIDIA Virtual GPU (vGPU)
Software branch 15 (driver branch R525), which has reached its end of
life in December 2023. We will therefore upgrade to branch 16 (driver
branch R535) which is a long term support (LTS) release and is
supported until July 2026.

The driver version on the hypervisors and the instances must match for
vGPU to function. Therefore, as the NREC team upgrades the
hypervisors, it will be necessary for the users to upgrade the driver
in their instances.

Updated vGPU images with the correct driver version will be released
after the upgrade is completed, negating the need to manually update
newly created instances.

Updating instance driver version
--------------------------------

This requires the user to log into their instance, download a file,
and run a command. We will outline the process here.

#. Log in to your instance::

     ssh -l <user> <ip-address>

#. Download the driver::

     cd /tmp
     curl -O https://download.iaas.uio.no/nrec-resources/files/nvidia-vgpu/NVIDIA-Linux-x86_64-535.154.05-grid.run

#. Install/Update the driver::

     sudo bash /tmp/NVIDIA-Linux-x86_64-535.154.05-grid.run --dkms --no-drm -n -s

#. Delete the driver bundle::

     rm /tmp/NVIDIA-Linux-x86_64-535.154.05-grid.run

#. Verify that the driver works by running **nvidia-smi**. The output
   should look like the example below:

   .. code-block:: console

      $ nvidia-smi
      +---------------------------------------------------------------------------------------+
      | NVIDIA-SMI 535.154.05             Driver Version: 535.154.05   CUDA Version: 12.2     |
      |-----------------------------------------+----------------------+----------------------+
      | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
      | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
      |                                         |                      |               MIG M. |
      |=========================================+======================+======================|
      |   0  GRID P40-12A                   On  | 00000000:05:00.0 Off |                  N/A |
      | N/A   N/A    P8              N/A /  N/A |      0MiB / 12288MiB |      0%   Prohibited |
      |                                         |                      |             Disabled |
      +-----------------------------------------+----------------------+----------------------+
                                                                                               
      +---------------------------------------------------------------------------------------+
      | Processes:                                                                            |
      |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
      |        ID   ID                                                             Usage      |
      |=======================================================================================|
      |  No running processes found                                                           |
      +---------------------------------------------------------------------------------------+

#. Reboot the instance (can be skipped)::

     reboot

