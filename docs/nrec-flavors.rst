.. |date| date::

NREC flavors
============

.. contents::

.. shared High-Performance Computing (sHPC): shpc.html
.. Virtual GPU Accelerated instance (vGPU): vgpu.html
.. support: support.html

The NREC Team provides many different flavors depending on use case and pricing. They generally follow the project type. The naming follows broadly:

- *m*: General purpose
- *c*: CPU intensive
- *d*: Disk intensive
- *r* RAM intensive
- win*: Disk intensive, Windows

You can see which flavors are available in your project in the Dasboard when creating an instance: Instances -> Lanuch Instance -> Flavor * , or using the CLI (here, sorted by RAM):

.. code-block:: console
   openstack flavor list --all --sort-column RAM

Personal
--------

+---------------------+------------+-------+-----------+---------------+
| Flavor Name         |Virtual CPUs|RAM    |Root disk  |Access         |
+=====================+============+=======+===========+===============+
|``m1.tiny``          |1           |512 MiB|2 GiB      |by default     |
+---------------------+------------+-------+-----------+---------------+
|``m1.small``         |1           |2 GiB  |10 GiB     |by default     |
+---------------------+------------+-------+-----------+---------------+
|``m1.medium``        |1           |4 GiB  |20 GiB     |by default     |
+---------------------+------------+-------+-----------+---------------+
|``m1.large``         |2           |8 GiB  |20 GiB     |by default     |
+---------------------+------------+-------+-----------+---------------+
|``m1.2xlarge``       |4           |16 GiB |20 GiB     |by default     |
+---------------------+------------+-------+-----------+---------------+
|``m2.2xlarge``       |8           |32 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``m2.4xlarge``       |16          |64 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``m2.8xlarge``       |32          |128 GiB|20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.medium``        |1           |2 GiB  |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.large``         |2           |4 GiB  |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.xlarge``        |4           |8 GiB  |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.2xlarge``       |8           |16 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.4xlarge``       |16          |32 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``c1.8xlarge``       |32          |64 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.small``         |1           |4 GiB  |40 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.medium``        |1           |4 GiB  |40 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.large``         |2           |8 GiB  |60 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.xlarge``        |4           |16 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.2xlarge``       |8           |32 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``d1.4xlarge``       |16          |64 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``r1.medium``        |1           |8 GiB  |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``r1.large``         |2           |16 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``r1.xlarge``        |4           |32 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``r1.2xlarge``       |8           |64 GiB |20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``r1.4xlarge``       |16          |128 GiB|20 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.small``        |1           |2 GiB  |40 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.medium``       |1           |4 GiB  |40 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.large``        |2           |8 GiB  |60 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.xlarge``       |4           |16 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.2xlarge``      |8           |32 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+
|``win.4xlarge``      |16          |64 GiB |80 GiB     |by request only|
+---------------------+------------+-------+-----------+---------------+

Shared
------

See the `shared High-Performance Computing (SHPC)`_ pages.

Virtual GPU
-----------

See `Virtual GPU Accelerated instance (vGPU)`_.

Custom
------

We additionally maintain custom flavors and hardware based on special needs. Please contact us on `support`_ for any inquiries.
