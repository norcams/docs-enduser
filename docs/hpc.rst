.. |date| date::

(BETA) High-Performance Computing (HPC)
=======================================

Last changed: |date|

.. contents::

.. _High-performance computing (HPC): https://en.wikipedia.org/wiki/Supercomputer
.. _Non-uniform memory access (NUMA): https://en.wikipedia.org/wiki/Non-uniform_memory_access
.. _AMD EPYC 7551 32-Core Processor: https://www.amd.com/en/products/cpu/amd-epyc-7551

This document describes the `High-performance computing (HPC)`_
service offering in UH-IaaS.

.. IMPORTANT::
   As of August 2019, the HPC service in UH-IaaS is in a beta or pilot
   stage. The stability in this service may be lacking compared to the
   standard UH-IaaS services.


What's different
================

The HPC service offering in UH-IaaS differs from the normal services
in a number of key ways. This is partly due to the fact that HPC
workloads differ from normal workloads:

* HPC workloads tend to actively use the resources (e.g. CPU and
  memory) that they are given. Normal workloads are mostly idle.

* HPC often needs large instances with lots of CPU and memory, while
  smaller instances is the norm for other workloads.

* HPC workloads have stricter requirements for CPU instruction sets,
  while normal workloads don't care about such details.

* Continuous uptime is not as important for HPC workloads, as they
  tend to run for a limited time period.

To satisfy the difference in requirements of HPC workloads the UH-IaaS
infrastructure for HPC is different in both hardware and setup:

+---------------------------------+---------------------------------+
| HPC                             | Normal                          |
+=================================+=================================+
| 2x `AMD EPYC 7551 32-Core       | Various model and generation    |
| Processor`_                     | Intel processors.               |
| per compute host. Up to 64      |                                 |
| physical cores plus threads.    |                                 |
+---------------------------------+---------------------------------+
| No overcommit of CPU or memory. | Resources such as CPU and memory|
|                                 | is overcommited, as workloads   |
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
overhead as possible for HPC workloads, live migration between hosts
is not possible. Unlike normal instances, HPC instances will be
subject to downtime due to planned and unplanned maintenance.

.. WARNING::
   Continous uptime can not be expected for HPC instances. Any
   instances running on a particular compute host will experience
   downtime when the compute host is down for maintenance.


Getting Access
==============

.. _support page: support.html

Please contact us for access to the HPC infrastructure. Use the normal
support channels as described in the `support page`_.

Note that the nature of HPC workloads allows for no overcommit of CPU
and memory resources. The HPC instances are consuming their CPU and
memory even when idle, and as a result HPC instances are much more
expensive than normal instances. **Please make sure to actually use
the resources given to an instance** whenever the instance is
running. Delete the instance when it's no longer needed.


Flavors for HPC
===============

We currently have the following flavors for use with HPC:

+------------------+--------------+---------+-------------------+
| Flavor name      | Virtual CPUs | Memory  | NUMA architecture |
+==================+==============+=========+===================+
| hpc.amd-epyc.8   | 8            | 30 GiB  | No                |
+------------------+--------------+---------+-------------------+
| hpc.amd-epyc.16  | 16           | 60 GiB  | No                |
+------------------+--------------+---------+-------------------+
| hpc.amd-epyc.32  | 32           | 120 GiB | Yes               |
+------------------+--------------+---------+-------------------+
| hpc.amd-epyc.64  | 64           | 240 GiB | Yes               |
+------------------+--------------+---------+-------------------+

Note that due to hardware constraints in the AMD EPYC CPU
architecture, instances that use a flavor with more than 16 CPUs will
have `Non-uniform memory access (NUMA)`_. The operating system and/or
the application will need to take that into account.

