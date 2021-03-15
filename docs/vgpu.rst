==============================================
(BETA) Virtual GPU Accelerated instance (vGPU)
==============================================

Last changed: 2021-03-21

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

* GPU: NVIDIA Tesla V100 PCIe 16GB (split between 4 instances)
* CPU: Intel Xeon Gold 5215 CPU @ 2.50GHz

**OSL:**

* GPU: NVIDIA Tesla P40 PCIe 24GB (split between 4 instances)
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
