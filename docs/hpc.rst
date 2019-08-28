.. |date| date::

(BETA) High-Performance Computing (HPC)
=======================================

Last changed: |date|

.. contents::

.. _High-performance computing (HPC): https://en.wikipedia.org/wiki/Supercomputer

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
| AMD EPYC processors. Up to 64   | Intel CPUs of various           |
| physical cores plus threads.    | generations.                    |
+---------------------------------+---------------------------------+
| No overcommit of CPU or memory. | Resources such as CPU and memory|
|                                 | is overcommited, as workloads   |
|                                 | usually don't use more than a   |
|                                 | fraction of the give resources. |
+---------------------------------+---------------------------------+
| Dedicated CPU cores. The        | No dedicated CPU cores.         |
| instance is given a number of   |                                 |
| CPU cores that is dedicated to  |                                 |
| that instance. No other         |                                 |
| instances will use the same     |                                 |
| cores.                          |                                 |
+---------------------------------+---------------------------------+
| NUMA awareness. The hypervisor  | No NUMA awareness.              |
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
subject to downtime due to normal maintenance.


