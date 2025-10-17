==============================================
Virtual GPU Accelerated instance (vGPU)
==============================================

Last changed: 2025-10-17

.. WARNING::
  This document is a work in progress.

.. contents::

.. _apply for an vGPU project: https://request.nrec.no/
.. _support page: support.html
.. _contact support: support.html
.. _NVIDIA Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
.. _Norwegian AI Cloud: https://naic.no

This document describes the use of Virtual GPU accelerated instances in NREC.

Policies and Getting Access
---------------------------

The following are the preliminary policies that are in effect for
access and use of the vGPU infrastructure. The main purpose of the
policies is to ensure that resources aren't wasted. The policies may
change in the future:

* Short lived (<= 48h) vGPU instances in NREC for use in AI/ML tasks are provided by `Norwegian AI Cloud`_. To apply, please contact support@nrec.no.

* For other vGPU instances required to run for a longer duration (~6 months), `apply for an vGPU project`_.

* We want "pure" vGPU projects for easier resource control.

* The vGPU resources must be used. Having instances running idle is not
  acceptable in the vGPU infrastructure.

* Delete the instance when it's no longer needed.

* You will not be able to use an existing project with vGPU.

If you paid for the hardware yourself, we will not interfere
in whether non-needed instances are deleted.

If you have any questions, please use the
normal support channels as described on our `support page`_.

Hardware
--------

There will be different types of hardware used in vGPU but this is the
initial setup:

**BGO:**

* GPU: NVIDIA Tesla V100 PCIe 16GB (each split between 2 instances)
* CPU: Intel Xeon Gold 5215 CPU @ 2.50GHz

**OSL:**

* GPU: NVIDIA Tesla P40 PCIe 24GB (each split between 2 instances)
* CPU: Intel Xeon Gold 6226R CPU @ 2.90GHz

Flavors
-------

We currently have the following flavors for use with vGPU:

+------------------+--------------+---------+---------+----------+----------+
|Flavor name       |Virtual CPUs  |Disk     |Memory   |Virtual   |Virtual   |
|                  |              |         |         |GPU (BGO) |GPU (OSL) |
+==================+==============+=========+=========+==========+==========+
|vgpu.m1.large     |2             |50 GB    |8 GiB    |V100 8 GiB|P40 12 GiB|
+------------------+--------------+---------+---------+----------+----------+
|vgpu.m1.xlarge    |4             |50 GB    |16 GiB   |V100 8 GiB|P40 12 GiB|
+------------------+--------------+---------+---------+----------+----------+
|vgpu.m1.2xlarge   |8             |50 GB    |32 GiB   |V100 8 GiB|P40 12 GiB|
+------------------+--------------+---------+---------+----------+----------+

Prebuilt images
---------------

The NREC Team provides prebuilt images with the vGPU driver already installed. We
strongly recommend using these, as vGPU drivers are not publicly available. These
images become available to your project when you are granted access to the vGPU
resources.

+------------------+-----------------------+
| Distribution     | Image name            |
+==================+=======================+
| Ubuntu 22.04 LTS | vGPU Ubuntu 22.04 LTS |
+------------------+-----------------------+
| Ubuntu 24.04 LTS | vGPU Ubuntu 24.04 LTS |
+------------------+-----------------------+
| Alma Linux 9.x   | vGPU Alma Linux 9     |
+------------------+-----------------------+
| Alma Linux 10.x   | vGPU Alma Linux 10   |
+------------------+-----------------------+


vGPU type
---------

Only the vGPU Compute Server type is available, so vGPU for graphics acceleration
and visualization is not available.


vGPU software product version
-----------------------------

The current version of the NVIDIA Grid Software is 15 (driver 525 series). When
the product version in the NREC infrastructure is upgraded, an upgrade of the
software in the running instances may be required. We will provide information
on how to upgrade running instances when necessary.


Testing basic vGPU funtionality
-------------------------------

When you login to your newly created vGPU instance, you can verify that the
vGPU device is present:

.. code-block:: console

  $ sudo lspci | grep -i nvidia
  05:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 16GB] (rev a1)

From this output it seems like you have got the whole PCIe card. However, running
the vGPU software reveals that you have only got a partition of the card:

.. code-block:: console

  $ nvidia-smi
  +-----------------------------------------------------------------------------+
  | NVIDIA-SMI 470.63.01    Driver Version: 470.63.01    CUDA Version: 11.4     |
  |-------------------------------+----------------------+----------------------+
  | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
  |                               |                      |               MIG M. |
  |===============================+======================+======================|
  |   0  GRID V100-8C        On   | 00000000:05:00.0 Off |                    0 |
  | N/A   N/A    P0    N/A /  N/A |    592MiB /  8192MiB |      0%      Default |
  |                               |                      |                  N/A |
  +-------------------------------+----------------------+----------------------+

  +-----------------------------------------------------------------------------+
  | Processes:                                                                  |
  |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
  |        ID   ID                                                   Usage      |
  |=============================================================================|
  |  No running processes found                                                 |
  +-----------------------------------------------------------------------------+

Now that we have verified that the vGPU is available and ready for use, we
are ready to install software that can utilize the accelerator. Only the drivers
are preinstalled in the NREC provided images.


Installation of CUDA libraries
------------------------------

.. WARNING::
   Do not use the package repositories provided by NVIDIA to install CUDA libraries.
   The dependency chain in these repositories forces the installation of generic
   NVIDIA display drivers witch removes the vGPU drivers provided by the NREC Team.
   Only install drivers and driver updates provided by the NREC Team.

.. NOTE::
   The CUDA library installation require a huge amount of space in addition to
   the instalaltion file itself. If you have a root disk of 20 GB, you will
   probably run into a full file system during the process. We recommend that
   you create a volume of at least 20 GB, create a filesystem on it and mount it
   temporarily somewhere, where you downlaod the file and perform the
   installation.
   This volume can be removed afterwards.

   NREC is considering creating vGPU flavors with a large root disk due to this
   issue.


Now head over to the download page on the NVIDIA website and select Drivers->All NVIDIA
Drivers. Search for Linux 64-bit drivers in the "Data Center / Tesla" product type.
Download and install the package installing only the CUDA libraries, excluding the driver,
but including samples for this example:

.. code-block:: console

  $ curl -O https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
  $ chmod +x cuda_12.2.2_535.104.05_linux.run
  $ sudo ./cuda_12.2.2_535.104.05_linux.run --silent --no-drm --samples --toolkit

After a while the installation is finished. Next step is to install a compiler
and test one of the samples. For Alma Linux 8 we install the compiler with yum:

.. code-block:: console

  $ dnf install -y gcc-c++

In Ubuntu we use apt-get:

.. code-block:: console

  $ apt-get install 'g++'

Finally run some provided demo applications to verify the system.

.. code-block:: console

  $ /usr/local/cuda/extras/demo_suite/deviceQuery
  $ /usr/local/cuda/extras/demo_suite/bandwidthTest

The commands should both produce output showing it find a GPU device.

Leverage vGPU support for containers
------------------------------

In order to leverage vGPU for containers, you need to install the `NVIDIA Container Toolkit`_.
The NVIDIA Container Toolkit allows users to build and run GPU accelerated containers.
The toolkit includes a container runtime library and utilities to automatically configure containers to leverage NVIDIA GPUs.

Install with Apt
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Configure the production repository:

.. code-block:: console

   $ curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
     && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
     sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
     sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

2. Update the packages list from the repository:

.. code-block:: console

   $ sudo apt-get update

3. Install the NVIDIA Container Toolkit packages:

.. code-block:: console

   $ sudo apt-get install -y nvidia-container-toolkit

Install with Yum or Dnf
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Configure the production repository:

.. code-block:: console

   $ curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
     sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

2. Install the NVIDIA Container Toolkit packages:

.. code-block:: console

   $ sudo dnf install -y nvidia-container-toolkit

Configure Docker to use Nvidia driver
~~~~~~~~~~~~~~~~~~~~~~~~~~

Configure the container runtime by using the nvidia-ctk command, and then restart the Docker daemon:

.. code-block:: console

   $ sudo nvidia-ctk runtime configure --runtime=docker
   $ sudo systemctl restart docker

**Rootless mode:**

To configure the container runtime for Docker running in Rootless mode, follow these steps:

1. Configure the container runtime by using the nvidia-ctk command:

.. code-block:: console

   $ nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json

2. Restart the Rootless Docker daemon:

.. code-block:: console

  $ systemctl --user restart docker

3. Configure /etc/nvidia-container-runtime/config.toml by using the sudo nvidia-ctk command:

.. code-block:: console

   $ sudo nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place

Running a Sample Workload with Docker and vGPU
~~~~~~~~~~~~~~~~~~~~~~~~~~

After you install and configure the toolkit and install an NVIDIA GPU Driver, you can verify your installation by running a sample workload.

* Run a sample CUDA container:

.. code-block:: console

   $ sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

Your output should look similar to the following:


.. code-block:: console

   +---------------------------------------------------------------------------------------+
   | NVIDIA-SMI 535.216.01             Driver Version: 535.216.01   CUDA Version: 12.2     |
   |-----------------------------------------+----------------------+----------------------+
   | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
   | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
   |                                         |                      |               MIG M. |
   |=========================================+======================+======================|
   |   0  GRID P40-12Q                   On  | 00000000:05:00.0 Off |                  N/A |
   | N/A   N/A    P8              N/A /  N/A |    388MiB / 12288MiB |      0%      Default |
   |                                         |                      |             Disabled |
   +-----------------------------------------+----------------------+----------------------+

   +---------------------------------------------------------------------------------------+
   | Processes:                                                                            |
   |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
   |        ID   ID                                                             Usage      |
   |=======================================================================================|
   |  No running processes found                                                           |
   +---------------------------------------------------------------------------------------+


Upgrading the instance drivers
------------------------------

The drivers of the hypervisor (the physical host containing the GPU cards the
instances utilizes) and those of the instances themselves, must correspond. Thus
the instances must have new drivers installed whenever the host is upgraded. We
attempt to minimize the number of such occurences, but for instance new kernels
might require updated drivers from the hardware vendor. All our GOLD offerings
have the up-to-date and correct version pre-installed, but any existing
instances must be updated as well. When this is the case, the users of any such
affected instance are notified and referred to this section for instructions on
how to perform this action.

In order to update or reinstall the vGPU drivers we need to determine
the newest installed kernel and build the driver for this kernel
version. Below are shell script snippets for Ubuntu and AlmaLinux,
which you can simply cut and paste and run in your instance to make
this work.

.. code-block:: bash

  # Get latest NVIDIA GRID package and build with dkms
  cd /tmp
  curl -O https://download.iaas.uio.no/nrec/nrec-resources/files/nvidia-vgpu/linux-grid-latest
  chmod +x linux-grid-latest
  sudo ./linux-grid-latest --dkms --no-drm -n -s

  # Clean up
  rm -f ./linux-grid-latest

After running the shell snippet you may need to reboot the instance.

Verify that the driver works by running **nvidia-smi**. The output
should look like the example below (it varies slightly between the OSL
and BGO regions):

.. code-block:: console

  $ nvidia-smi
  +---------------------------------------------------------------------------------------+
  | NVIDIA-SMI 535.154.05             Driver Version: 535.154.05   CUDA Version: 12.2     |
  |-----------------------------------------+----------------------+----------------------+
  | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
  |                                         |                      |               MIG M. |
  |=========================================+======================+======================|
  |   0  GRID P40-12Q                   On  | 00000000:05:00.0 Off |                  N/A |
  | N/A   N/A    P8              N/A /  N/A |   2318MiB / 12288MiB |      0%      Default |
  |                                         |                      |             Disabled |
  +-----------------------------------------+----------------------+----------------------+

  +---------------------------------------------------------------------------------------+
  | Processes:                                                                            |
  |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
  |        ID   ID                                                             Usage      |
  |=======================================================================================|
  |    0   N/A  N/A      1104      C   python3                                    2318MiB |
  +---------------------------------------------------------------------------------------+
After running the shell snippet you may need to reboot the instance.

Checking license status and getting client token
------------------------------
This is how you can check the NVIDIA gridd license status

.. code-block:: bash

  ## By running nvidia-smi

  ## This is an example output if you do not have a license
  nvidia-smi  -q | grep -i license
  vGPU Software Licensed Product
    License Status                    : Unlicensed


  ## This is an example output if you have a license
  nvidia-smi  -q | grep -i license
  vGPU Software Licensed Product
    License Status   : Licensed (Expiry: 2024-10-19 6:51:17 GMT)

  ## This is another way you can check the status
  systemctl status nvidia-gridd
  ## This is an example output (BGO) for a llicsensed product
  # Oct 18 07:03:40 vgpu-test nvidia-gridd[2388]: Acquiring license. (Info: lisens88.uib.no; NVIDIA RTX Virtual Workstation)
  # Oct 18 07:03:42 vgpu-test nvidia-gridd[2388]: License acquired successfully. (Info: lisens88.uib.no, NVIDIA RTX Virtual Workstation; Expiry: 2024-10-19 7:3:42 GMT)

  # This is en example output of you are missing the client token
  # Oct 18 06:55:46 vgpu-test nvidia-gridd[1985]: Unable to fetch the client configuration token file

If you do not have a client token then you can fetch it and restart nvidia-gridd service

**BGO REGION**

.. code-block:: bash

  ## Get latest NVIDIA GRID client token for BGO
  cd /tmp
  curl -O https://download.iaas.uio.no/nrec/nrec-resources/files/nvidia-vgpu/bgo-client-token-latest
  sudo mv bgo-client-token-latest /etc/nvidia/ClientConfigToken/
  sudo systemctl status nvidia-gridd
  ## You can either wait for the nvidia-gridd service to recognize there now is a (valid) token file or restart the service

  ## If all is okay, then the output could loook something like this
  # Oct 18 06:58:26 vgpu88 nvidia-gridd[1985]: NLS initialized
  # Oct 18 06:58:26 vgpu88 nvidia-gridd[1985]: Acquiring license. (Info: lisens88.uib.no; NVIDIA RTX Virtual Workstation)
  # Oct 18 06:58:28 vgpu88 nvidia-gridd[1985]: License acquired successfully. (Info: lisens88.uib.no, NVIDIA RTX Virtual Workstation; Expiry: 2024-10-19 6:58:28 GMT



Known issues
------------

* Drivers: you should use the official NREC vGPU images with preinstalled
  drivers. These drivers must not be changed or updated without instructions
  from the NREC Team. Specifically; never install stock NVIDIA Drivers found
  on the NVIDIA web page or those drivers found in the CUDA repositories.
  Those drivers do not support vGPU and will break the vGPU functionality.
  If you do not have access to the NREC vGPU images, please
  `contact support`_ and ask for access.

* Starting more than one instance with vGPU at the same time might result
  in some of them ending in an error state. This can be solved by deleting
  them and try to starting again. We recommend only starting one at the
  time to avoid this bug.
