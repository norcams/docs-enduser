.. |date| date::

Dedicated Computing
===================

Last changed: 2026-08-17

.. contents::

.. _Shared HPC: shpc.html

.. _IMPORTANT: **Only available in OSL**
   The dedicated compute service is only available in the OSL region.

This document describes the **Dedicated Computing** service offering in
NREC. This service differs from the general compute service in one key
area:

The resources assigned to an instance are "dedicated", in the sense
that there is no sharing or overcommit of resources. This applies to
CPU and RAM resources, that are usually shared among instances. In the
dedicated service, actual CPU cores and memory chunks are assigned
exclusively to the instance.**

Note that network resources (including disk I/O) are still shared
among instances running on the hypervisor.

Due to the nature of the dedicated resources, live migration of
instances between hypervisors is difficult or impossible. This in turn
means that downtime on a hypervisor, such as scheduled downtime due to
maintenance, also applies to the instances running on that hypervisor.


When to use the dedicated service
---------------------------------

There are two usecases where the dedicated service is useful:

**Critical Instances:**
  Instances that are highly critical for a limited time, such as
  instances running exam software. The dedicated resources assures
  that no other instances on the hypervisor can interfere by causing
  resource starvation.

**Heavy Performance Needs:**
  Running high-performance computing (HPC) or complex database engines
  requiring predictable throughput. Instances that utilize 100% CPU
  and/or memory for an extended time period, i.e. HPC workloads. Such
  instances may not fit in a shared environment such as `Shared HPC`_.

There may be other usecases that we haven't identified.


Getting Access
--------------

Please contact us via `email:support@nrec.no` for access to this
service.


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
