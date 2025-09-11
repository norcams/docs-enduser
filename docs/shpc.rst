.. |date| date::

shared High-Performance Computing (sHPC)
========================================

Last changed: |date|

.. contents::

.. _apply for a project: http://request.nrec.no/
.. _support page: support.html

This document describes the shared High-performance computing (sHPC)
service offering in NREC.


What's different
----------------

The sHPC service offering in NREC differs slightly from the normal
services. The purpose is to offer flavors for compute or memory hungry
workloads and isolate them from impacting workloads in the normal
services.

* sHPC workloads are still sharing resources in the same way as in
  the normal services, albeit with much less overcommit ratios. This
  ensures that the workloads in the sHPC service are guaranteed a
  high degree of available resources even though there are no
  dedicated resources. This leads to better resource utilization for
  the NREC infrastructure.

* The sHPC service has three flavor sets weighted for compute and
  memory intensive workloads respectively. Read more about the available
  flavors belov.

* Continuous uptime is not provided in sHPC service because the
  instances have their hard drive located locally on the hypervisors.
  Instances will be taken down in planned maintainance windows, scheduled
  for the second Tuesday of the month.


These are the key differences in the NREC infrastructure for sHPC
instances compared to normal instances:

+---------------------------------+---------------------------------+
| sHPC                            | Normal                          |
+=================================+=================================+
| AMD EPYC processors, 2nd gen    | Various model and generation    |
| or newer.                       | Intel processors.               |
+---------------------------------+---------------------------------+
| Slight overcommitment of        | Resources such as CPU and memory|
| CPU and memory for best         | are overcommitted, as workloads |
| resorce utilization             | usually don't use more than a   |
|                                 | fraction of the given resources.|
+---------------------------------+---------------------------------+
| Maintainance windows forcing    | No scheduled downtime for       |
| instances to be shut down       | instances.                      |
| while the NREC team performs    |                                 |
| upgrades on the hypervisors.    |                                 |
+---------------------------------+---------------------------------+


Getting Access
--------------

Please use the normal form to `apply for a project`_ and apply for a
shared project, then check the box "Need access to shared HPC" in
order to gain access to the sHPC flavors. If you already have a shared
project, please use the normal support channels as described on our
`support page`_ in order to apply for access.


Flavors
-------

The sHPC flavors are divided into three categories:

+------------+-------------------+---------------------------+
|Flavor Type |Available in Region|Main Purpose               |
+============+===================+===========================+
|``shpc.m1a``|BGO, OSL           |Balanced workloads         |
+------------+-------------------+---------------------------+
|``shpc.c1a``|BGO, OSL           |Compute intensive workloads|
+------------+-------------------+---------------------------+
|``shpc.r1a``|BGO, OSL           |Memory intensive worklads  |
+------------+-------------------+---------------------------+

In addition, we have the following disk optimized flavor sets. These
use local NVMe or SSD storage on the hypervisor:

+--------------+---------+---------------------------+
|Flavor Type   |Disk Size|Main Purpose               |
+==============+=========+===========================+
|``shpc.m1ad1``|200 GB   |Balanced workloads         |
+--------------+---------+---------------------------+
|``shpc.m1ad2``|500 GB   |Balanced workloads         |
+--------------+---------+---------------------------+
|``shpc.m1ad3``|1000 GB  |Balanced workloads         |
+--------------+---------+---------------------------+
|``shpc.m1ad4``|2000 GB  |Balanced workloads         |
+--------------+---------+---------------------------+
|``shpc.c1ad1``|200 GB   |Compute intensive workloads|
+--------------+---------+---------------------------+
|``shpc.c1ad2``|500 GB   |Compute intensive workloads|
+--------------+---------+---------------------------+
|``shpc.c1ad3``|1000 GB  |Compute intensive workloads|
+--------------+---------+---------------------------+
|``shpc.c1ad4``|2000 GB  |Compute intensive workloads|
+--------------+---------+---------------------------+

The disk optimized flavors are identical to their «m1a» and «c1a»
counterparts, except for the OS disk size. The disk optimized flavors
are only available by request.

Detailed information about the sHPC flavors:

+---------------------+------------+-------+---------------+
| Flavor Name         |Virtual CPUs|Memory | Access        |
+=====================+============+=======+===============+
|``shpc.m1a.2xlarge`` | 8          |32 GiB | by default    |
+---------------------+------------+-------+---------------+
|``shpc.m1a.4xlarge`` | 16         |64 GiB | by default    |
+---------------------+------------+-------+---------------+
|``shpc.m1a.8xlarge`` | 32         |128 GiB| by default    |
+---------------------+------------+-------+---------------+
|``shpc.c1a.2xlarge`` | 8          |16 GiB | by default    |
+---------------------+------------+-------+---------------+
|``shpc.c1a.4xlarge`` | 16         |32 GiB | by default    |
+---------------------+------------+-------+---------------+
|``shpc.c1a.8xlarge`` | 32         |64 GiB | by default    |
+---------------------+------------+-------+---------------+
|``shpc.c1a.16xlarge``| 64         |128 GiB| by default    |
+---------------------+------------+-------+---------------+
|``shpc.r1a.xlarge``  | 4          |32 GiB |by request only|
+---------------------+------------+-------+---------------+
|``shpc.r1a.2xlarge`` | 8          |64 GiB |by request only|
+---------------------+------------+-------+---------------+
|``shpc.r1a.4xlarge`` | 16         |128 GiB|by request only|
+---------------------+------------+-------+---------------+
|``shpc.r1a.8xlarge`` | 32         |256 GiB|by request only|
+---------------------+------------+-------+---------------+
|``shpc.r1a.12xlarge``| 48         |384 GiB|by request only|
+---------------------+------------+-------+---------------+
|``shpc.r1a.16xlarge``| 64         |512 GiB|by request only|
+---------------------+------------+-------+---------------+

The therm vCPU refers to physical threads, which is two pr physical
CPU core. So, 64 vCPUs translates into 32 physical, multithreaded real
CPU cores.
