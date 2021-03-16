==============================================
(BETA) Virtual GPU Accelerated instance (vGPU)
==============================================

Last changed: 2021-03-16

.. WARNING::
  This document is a work in progress. More information to come.

.. contents::

.. _apply for an vGPU project: https://request.nrec.no/
.. _support page: support.html
.. _contact support: support.html

This document describes the use of Virtual GPU accelerated instances in NREC.


.. IMPORTANT::
   The vGPU service in NREC is in a beta stage. The stability in
   this service may be lacking compared to the standard NREC
   services.

Getting Access
--------------

Please use the normal form to `apply for an vGPU project`_, for access
to the GPU infrastructure. If you have any questions, please use the
normal support channels as described on our `support page`_. You will
not be able to use an existing project with vGPU.

Policies
--------

The following are the preliminary policies that are in effect for
access and use of the vGPU infrastructure. The main purpose of the
policies is to ensure that resources aren't wasted. The policies may
change in the future:

* We want "pure" vGPU projects for easier resource control. To use the
  vGPU infrastructure, `apply for an vGPU project`_.

* vGPU projects must have an end date.

* The vGPU resources must be used. Having instances running idle is not
  acceptable in the vGPU infrastructure.

* Delete the instance when it's no longer needed.

If you paid for the hardware yourself only the first two policies apply.

Hardware
--------

There will be different types of hardware used in vGPU but this is the
initial setup:

**BGO:**

* GPU: NVIDIA Tesla V100 PCIe 16GB (each split between 4 instances)
* CPU: Intel Xeon Gold 5215 CPU @ 2.50GHz

**OSL:**

* GPU: NVIDIA Tesla P40 PCIe 24GB (each split between 4 instances)
* CPU: Intel Xeon Gold 6226R CPU @ 2.90GHz

Flavors
-------

We currently have the following flavors for use with vGPU:

+------------------+--------------+---------+
| Flavor name      | Virtual CPUs | Memory  |
+==================+==============+=========+
| vgpu.m1.large    | 2            |  8 GiB  |
+------------------+--------------+---------+
| vgpu.m1.xlarge   | 4            | 16 GiB  |
+------------------+--------------+---------+
| vgpu.m1.2xlarge  | 8            | 32 GiB  |
+------------------+--------------+---------+

Prebuild images
---------------

The NREC Team provides prebuild images with the vGPU driver already installed. We
strongly recommend using these, as vGPU drivers are not publicly available. These
images become available to your project when you are granted access to the vGPU
resources.

+------------------+-----------------------+
| Distribution     | Image name            |
+==================+=======================+
| Ubuntu 20.04 LTS | vGPU Ubuntu 20.04 LTS |
+------------------+-----------------------+
| CentOS 7.x       | vGPU CentOS 7         |
+------------------+-----------------------+
| CentOS 8.x       | vGPU CentOS 8         |
+------------------+-----------------------+


vGPU type
---------

Only the vGPU Compute Server type is available, so vGPU for graphics acceleration
and visualization is not available.


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
  | NVIDIA-SMI 450.89       Driver Version: 450.89       CUDA Version: 11.0     |
  |-------------------------------+----------------------+----------------------+
  | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
  |                               |                      |               MIG M. |
  |===============================+======================+======================|
  |   0  GRID V100-4C        On   | 00000000:05:00.0 Off |                    0 |
  | N/A   N/A    P0    N/A /  N/A |    304MiB /  4096MiB |      0%      Default |
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

Now head over to the download page on the NVIDIA website and select Drivers->All NVIDIA
Drivers. Search for Linux 64-bit drivers in the "Data Center / Tesla" product type.
Download and install the package installing only the CUDA libraries, excluding the driver,
but including samples for this example:

.. code-block:: console

  $ curl -O https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
  $ chmod +x cuda_11.2.2_460.32.03_linux.run
  $ sudo ./cuda_11.2.2_460.32.03_linux.run --silent --no-drm --samples --toolkit

After a while the installation is finished. Next step is to install a compiler
and test one of the samples. For CentOS 7 we install the compiler with yum:

.. code-block:: console

  $ yum install gcc-c++

The final test is to actually compile some code and run it.

.. code-block:: console

  $ cd /usr/local/cuda/samples/0_Simple/simpleAWBarrier
  $ make
  $ ./simpleAWBarrier 
  ./simpleAWBarrier starting...
  GPU Device 0: "Volta" with compute capability 7.0
  
  Launching normVecByDotProductAWBarrier kernel with numBlocks = 160 blockSize = 640
  Result = PASSED
  ./simpleAWBarrier completed, returned OK


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
