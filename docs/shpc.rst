.. |date| date::

shared High-Performance Computing (sHPC)
========================================

Last changed: |date|

.. contents::

.. _High-performance computing (HPC): https://en.wikipedia.org/wiki/Supercomputer
.. _Non-uniform memory access (NUMA): https://en.wikipedia.org/wiki/Non-uniform_memory_access
.. _AMD EPYC 7551 32-Core Processor: https://www.amd.com/en/products/cpu/amd-epyc-7551
.. _AMD EPYC 7552 48-Core Processor: https://www.amd.com/en/products/cpu/amd-epyc-7552
.. _apply for an HPC project: http://request.nrec.no/
.. _support page: support.html

This document describes the shared High-performance computing (sHPC)
service offering in NREC.

.. NOTE::
   The sHPC service is available in the BGO region only.


What's different
----------------

The sHPC service offering in NREC differs slightly from the normal
services. The purpose is to offer flavors for compute or memory hungry
workloads and isolate them from hogging resources in the normal
services.

* sHPC workloads are still sharing resources in the same way as in
  the normal services, albeit with much less overcommit ratios. This
  ensures that the workloads in the sHPC service are guaranteed a
  high degree of available resources even though there are no
  dedicated resources. This leads to better resource utilization for
  the NREC infrastructure.

* The sHPC service has two flavor sets weighted for compute and
  memory intensive workloads respectively. Read more about the available
  flavors belov.

* Continuous uptime is not provided in sHPC service because the
  instances have their hard drive located locally on the hypervisors.
  Instances will be taken down in planned maintainance windows, scheduled
  for the second Tuesday of the month.


To satisfy the difference in requirements of HPC workloads the NREC
infrastructure for HPC is different in both hardware and setup:

+---------------------------------+---------------------------------+
| HPC                             | Normal                          |
+=================================+=================================+
| AMD EPYC processors. Details    | Various model and generation    |
| are listed below.               | Intel processors.               |
+---------------------------------+---------------------------------+
| No overcommit of CPU or memory. | Resources such as CPU and memory|
|                                 | are overcommitted, as workloads |
|                                 | usually don't use more than a   |
|                                 | fraction of the given resources.|
+---------------------------------+---------------------------------+
| Dedicated CPU cores. The        | No dedicated CPU cores.         |
| instance is given a number of   |                                 |
| CPU cores that is dedicated to  |                                 |
| that instance. No other         |                                 |
| instances will use the same     |                                 |
| cores.                          |                                 |
+---------------------------------+---------------------------------+
| `Non-uniform memory access      | No NUMA awareness.              |
| (NUMA)`_ awareness. The         |                                 |
| hypervisor                      |                                 |
| makes sure that the allotted    |                                 |
| resources for the instance are  |                                 |
| all within as few NUMA nodes as |                                 |
| possible.                       |                                 |
+---------------------------------+---------------------------------+
| Hugepage memory. The memory for | Normal memory mapping.          |
| instances is allocated in a     |                                 |
| hugepage memory pool to speed   |                                 |
| up memory access.               |                                 |
+---------------------------------+---------------------------------+

Because of the various steps taken to ensure consistency and as little
performance overhead as possible for HPC workloads, live migration of
instances between compute hosts is not possible. Unlike normal
instances, HPC instances will be subject to downtime due to planned
and unplanned maintenance.

.. WARNING::
   Continuous uptime can not be expected for HPC instances. Any
   instances running on a particular compute host will experience
   downtime when the compute host is down for maintenance.

   Please note that, there will be scheduled maintenance on the
   second Tuesday of every month.


Getting Access
--------------

Please use the normal form to `apply for an HPC project`_, for access
to the HPC infrastructure. If you have any questions, please use the
normal support channels as described on our `support page`_.


Policies
--------

The following are the preliminary policies that are in effect for
access and use of the HPC infrastructure. The main purpose of the
policies is to ensure that resources aren't wasted. The policies may
change in the future:

* We want "pure" HPC projects for easier resource control. To use the
  HPC infrastructure, `apply for an HPC project`_.

* HPC projects must have an end date.

* The HPC resources must be used. Having instances running idle is not
  acceptable in the HPC infrastructure.

Note that the nature of HPC workloads does not allow overcommit of CPU
and memory resources. The HPC instances are consuming their CPU and
memory resources even when idle. As a result HPC instances are much
more expensive than normal instances. **Please make sure to actually
use the resources given to an instance** whenever the instance is
running. Delete the instance when it's no longer needed.


Hardware
--------

The hardware used for HPC is listed below.

For generic HPC workloads:

* 4 x compute hosts (hypervisors) with:

  - 2 x `AMD EPYC 7551 32-Core Processor`_
  - 512 GiB memory

For CERN ATLAS workloads:

* 10 x compute hosts (hypervisors) with:

  - 2 x `AMD EPYC 7551 32-Core Processor`_
  - 512 GiB memory

* 12 x compute hosts (hypervisors) with:

  - 2 x `AMD EPYC 7552 48-Core Processor`_
  - 512 GiB memory



Flavors
-------

We currently have the following flavors for use with HPC:

+------------------+--------------+---------+-------------------+
| Flavor name      | Virtual CPUs | Memory  | NUMA architecture |
+==================+==============+=========+===================+
| hpc.m1a.2xlarge  | 8            | 30 GiB  | No                |
+------------------+--------------+---------+-------------------+
| hpc.m1a.4xlarge  | 16           | 60 GiB  | No                |
+------------------+--------------+---------+-------------------+
| hpc.m1a.8xlarge  | 32           | 120 GiB | Yes               |
+------------------+--------------+---------+-------------------+
| hpc.m1a.16xlarge | 64           | 240 GiB | Yes               |
+------------------+--------------+---------+-------------------+


.. IMPORTANT::
   The therm vCPU refers to physical threads, which is two pr physical
   CPU core. So, 64 vCPUs translates into 32 physical, multithreaded
   real CPU cores.


Note that due to hardware constraints in the AMD EPYC CPU
architecture, instances that use a flavor with more than 16 vCPUs will
have `Non-uniform memory access (NUMA)`_. The operating system and/or
the application may need to take that into account.

