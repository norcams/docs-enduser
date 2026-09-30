Project application
===================

Demo projects
-------------

On first login at `access.nrec.no`_ with Feide credentials you are
automatically allocated a **demo project**. This is not applied for —
it is created automatically. Demo projects have a fixed default quota
that cannot be altered and instances with a maximum lifetime of 90 days.

.. _access.nrec.no: https://access.nrec.no/

If you need additional resources or a project in which you wish to
collaborate with other users, you can apply for different types of
projects through the request portal at `this web form`_.

.. _this web form: https://request.nrec.no


Applying for additional projects
--------------------------------

* **Personal projects**: Single-user projects. See `Personal projects`_
  below. See the quota tables below; when applying you must specify a
  tier (small, medium, or large).

* **Shared projects**: Multi-user projects. See `Shared projects`_
  below. Users can be added or removed at any time. Quotas are
  specified per project and adjusted by contacting support.

* **vGPU projects**: GPU-assisted compute for accelerated desktops,
  AI/ML workloads, and other GPU-accelerated tasks. Quotas are per
  vGPU instance and multiplied by the requested count. See
  `Virtual GPU Accelerated instance (vGPU) <vgpu.html>`_ for
  details.


Quotas
------

Quotas are set per project type. The **default** quota is applied to
demo projects and cannot be altered.

The default quota is:

=================== ===========
 Quota               Default
=================== ===========
 Instances           2
 vCPU                2
 Memory              2048 MB
 Number of volumes   1
 Volume size         20 GB
 Volume snapshots    3
=================== ===========

The **small** tier provides:

=================== ===========
 Quota               Small
=================== ===========
 Instances           5
 vCPU                10
 Memory              16 GB
 Number of volumes   5
 Volume size         100 GB
 Volume snapshots    10
=================== ===========

The **medium** tier provides:

=================== ===========
 Quota               Medium
=================== ===========
 Instances           20
 vCPU                40
 Memory              64 GB
 Number of volumes   20
 Volume size         200 GB
 Volume snapshots    40
=================== ===========

The **large** tier provides:

=================== ===========
 Quota               Large
=================== ===========
 Instances           50
 vCPU                100
 Memory              96 GB
 Number of volumes   20
 Volume size         500 GB
 Volume snapshots    40
=================== ===========

Quota definitions
~~~~~~~~~~~~~~~~~

**Instances**
  The total number of instances possible to create in a project.

**vCPU**
  The number of processors (vCPU) available to an instance.

**Memory**
  The amount of memory availble to an instance.

**Number of volumes**
  In NREC, block storage is called volume. The number indicates how many
  volumes are available in a project.

**Volume size**
  The total size of all volumes in a project.

**Volume snapshots**
  The total number of snapshots of all volumes in a project.


.. _Personal projects:

Personal projects
~~~~~~~~~~~~~~~~~

Personal projects are used by only one user. Only you will have
access to your personal project.


.. _Shared projects:

Shared projects
~~~~~~~~~~~~~~~

Shared projects can have multiple users. Users can be added or
removed at any time, but access control is done by contacting
NREC support. In order to add a user, the user must have logged
in to NREC at least once, else the user isn't known in the
system. Shared project quotas are adjusted by contacting support
at `support@nrec.no <support.html>`_.