.. |date| date::

Dedicated Computing
===================

Last changed: 2026-08-17

.. contents::

.. _Shared HPC: shpc.html

.. _High-performance computing (HPC): https://en.wikipedia.org/wiki/Supercomputer
.. _Non-uniform memory access (NUMA): https://en.wikipedia.org/wiki/Non-uniform_memory_access
.. _AMD EPYC 7551 32-Core Processor: https://www.amd.com/en/products/cpu/amd-epyc-7551
.. _AMD EPYC 7552 48-Core Processor: https://www.amd.com/en/products/cpu/amd-epyc-7552
.. _apply for an HPC project: http://request.nrec.no/
.. _support page: support.html

This document describes the **Dedicated Computing** service offering in
NREC. This service differs from the general compute service in one key
area:

**The resources assigned to an instance are "dedicated", in the sense
  that there is no sharing or overcommit of resources. This applies
  to CPU and RAM resources, that are usually shared among
  instances. In the dedicated service, actual CPU cores and memory
  chunks are assigned exclusively to the instance.**

Note that network resources are still shared among instances running
on the hypervisor.
  
Due to the nature of the dedicated resources, live migration of
instances between hypervisors is difficult or impossible. This in turn
means that downtime on a hypervisor, such as scheduled downtime due to
maintenance, also applies to the instances running on that hypervisor.


When to use the dedicated service
---------------------------------

There are two usecases where the dedicated service is useful:

#. Instances that are highly critical for a limited time, such as
   instances running exam software. The dedicated resources assures
   that no other instances on the hypervisor can interfere by causing
   resource starvation.

#. Instances that utilize 100% CPU and/or memory for an extended time
   period, i.e. HPC workloads. Such instances may not fit in a shared
   environment such as `Shared HPC`_.

There may be other usecases that we haven't identified.


Getting Access
--------------

Please contact us via `email:support@nrec.no` for access to this
service.


Hardware
--------

The hardware used for the dedicated service is listed below.

* 4 x compute hosts (hypervisors) with:

  - 2 x `AMD EPYC 7551 32-Core Processor`_
  - 512 GiB memory



Flavors
-------

We currently have the following flavors for use with dedicated
hardware:

+----------------------+--------------+---------+
| Flavor name          | Virtual CPUs | Memory  |
+======================+==============+=========+
|dedicated.m1a.2xlarge | 8            | 30 GiB  |
+----------------------+--------------+---------+
|dedicated.m1a.4xlarge | 16           | 60 GiB  |
+----------------------+--------------+---------+
|dedicated.m1a.8xlarge | 32           | 120 GiB |
+----------------------+--------------+---------+
|dedicated.m1a.16xlarge| 64           | 240 GiB |
+----------------------+--------------+---------+


.. IMPORTANT::
   The therm vCPU refers to physical threads, which is two pr physical
   CPU core. So, 64 vCPUs translates into 32 physical, multithreaded
   real CPU cores.


Note that due to hardware constraints in the AMD EPYC CPU
architecture, instances that use a flavor with more than 16 vCPUs will
have `Non-uniform memory access (NUMA)`_. The operating system and/or
the application may need to take that into account.

