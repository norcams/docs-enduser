.. |date| date::

shared High-Performance Computing (sHPC)
========================================

Last changed: |date|

.. contents::

.. _apply for a project: http://request.nrec.no/
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

+-------------------+-------------------------------------+
| Flavor type       | Main purpose                        |
+===================+=====================================+
| shpc.m1a          | Balanced workloads                  |
+-------------------+-------------------------------------+
| shpc.c1a          | Compute intensive workloads         |
+-------------------+-------------------------------------+
| shpc.r1a          | Memory intensive worklads           |
+-------------------+-------------------------------------+


We currently have the following flavors for use with sHPC:

+-------------------+--------------+---------+-----------------+
| Flavor name       | Virtual CPUs | Memory  | Access          |
+===================+==============+=========+=================+
| shpc.m1a.2xlarge  | 8            | 32 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.m1a.4xlarge  | 16           | 64 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.m1a.8xlarge  | 32           | 128 GiB | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.c1a.2xlarge  | 8            | 16 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.c1a.4xlarge  | 16           | 16 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.c1a.8xlarge  | 32           | 16 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.c1a.16xlarge | 64           | 16 GiB  | by default      |
+-------------------+--------------+---------+-----------------+
| shpc.r1a.xlarge   | 4            | 32 GiB  | by request only |
+-------------------+--------------+---------+-----------------+
| shpc.r1a.2xlarge  | 8            | 64 GiB  | by request only |
+-------------------+--------------+---------+-----------------+
| shpc.r1a.4xlarge  | 16           | 128 GiB | by request only |
+-------------------+--------------+---------+-----------------+
| shpc.r1a.8xlarge  | 32           | 256 GiB | by request only |
+-------------------+--------------+---------+-----------------+
| shpc.r1a.12xlarge | 48           | 384 GiB | by request only |
+-------------------+--------------+---------+-----------------+


.. IMPORTANT::
   The therm vCPU refers to physical threads, which is two pr physical
   CPU core. So, 64 vCPUs translates into 32 physical, multithreaded
   real CPU cores.
