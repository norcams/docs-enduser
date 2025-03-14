Resizing a Server
=================

Last changed: 2025-03-14

.. contents::

It is possible to resize a server (instance) by changing to a
different flavor. This has some caveats and pitfalls, however. Be sure
to have a backup of important data in case it goes wrong!


Caveats and Pitfalls
--------------------

Resizing can sometimes be unpredictable, and worst case is that the
instance is destroyed and unrecoverable. Follow these simple policies
for best results:

#. **Only within the same flavor class**

   You can resize between flavors in the same class of flavors,
   e.g. between ``m1``, ``c1`` and ``d1`` flavors. Examples:

   - ``m1.small`` → ``m1.large``
   - ``m1.small`` → ``d1.small``
   - ``m1.medium`` → ``c1.medium``
   - ``shpc.m1a.2xlarge`` → ``shpc.c1a.4xlarge``
   - ``shpc.m1a.2xlarge`` → ``shpc.m1ad1.2xlarge``

   You can not resize between e.g. ``m1`` and ``shpc.m1a``.

#. **The disk of the new flavor must be same size or larger**

   An attempt to resize into a flavor with a smaller disk size will
   fail. The instance will be fine, but resizing will simply fail.

#. **Do not resize vGPU instances**

   Due to the nature of vGPU these instances can not be resized. Your
   only option is to delete the existing vGPU instance and create a
   new with a different flavor.

#. **Do not leave the instance in VERIFY_RESIZE state**

   The resize process involves two steps, where the last step is to
   confirm or revert the resize. Instances that are being resized and
   not yet confirmed or reverted should not be used in any form of
   production. They will also interfere with NREC maintenance as they
   cannot be migrated while in this state.


How to Resize
-------------

The example shows how to resize from ``m1.small`` to
``m1.large``. This will be fine as both flavors are in the ``m1``
flavor set, and we're resizing to a larger disk (10GB → 20GB).

Via NREC Dashboard
~~~~~~~~~~~~~~~~~~

#. Navigate to **Compute** → **Instances**:

   .. figure:: images/server-resize-01.png
      :align: center
      :alt: Instance Tab

#. In the drop-down menu, select **Resize Instance**:
   
   .. figure:: images/server-resize-02.png
      :align: center
      :alt: Instance → Resize

#. In the pop-up window, select ``m1.large`` as the new flavor and
   click **Resize**:

   .. figure:: images/server-resize-03.png
      :align: center
      :alt: Select flavor

   The system will now use the original instance as an image when
   creating a new instance using the new flavor, while backing up the
   original instance.

#. You now have the option to either confirm or revert the resize
   operation. Log into the instance, check that it works. You should
   be able to confirm that it is using the larger flavor.

   If you want to *confirm* the resize, select **Confirm Resize/Migrate**:

   .. figure:: images/server-resize-04.png
      :align: center
      :alt: Confirm Resize/Migrate

   If you want to *revert* the resize, select **Revert
   Resize/Migrate** in the drop-down menu:

   .. figure:: images/server-resize-05.png
      :align: center
      :alt: Revert Resize/Migrate

#. If you opted to confirm the resize, the instance is now resized:

   .. figure:: images/server-resize-06.png
      :align: center
      :alt: Resize Finished

Via OpenStack CLI
~~~~~~~~~~~~~~~~~

The procedure is the same with OpenStack CLI:

#. We start with an instance of flavor ``m1.small``:

   .. code-block:: console

     $ openstack server list
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
     | ID                                   | Name        | Status | Networks                               | Image             | Flavor   |
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
     | 12fe44f6-b9ca-4317-9626-9492a6d348f2 | resize-test | ACTIVE | IPv6=10.2.3.166, 2001:700:2:8201::1010 | GOLD Alma Linux 9 | m1.small |
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+

#. Initiate the resize:

   .. code-block:: console

     $ openstack server resize --flavor m1.large 12fe44f6-b9ca-4317-9626-9492a6d348f2

#. After a few moments, the server should be in status
   ``VERIFY_RESIZE``:

   .. code-block:: console

     $ openstack server show 12fe44f6-b9ca-4317-9626-9492a6d348f2 -c status
     +-----------+---------------+
     | Field     | Value         |
     +-----------+---------------+
     | status    | VERIFY_RESIZE |
     +-----------+---------------+

#. You now have the option to either confirm or revert the resize
   operation. Log into the instance, check that it works. You should
   be able to confirm that it is using the larger flavor.

   If you want to *confirm* the resize, run:

   .. code-block:: console

     $ openstack server resize confirm 12fe44f6-b9ca-4317-9626-9492a6d348f2

   If you want to *revert* the resize, run:

   .. code-block:: console

     $ openstack server resize revert 12fe44f6-b9ca-4317-9626-9492a6d348f2

#. If you opted to confirm the resize, the instance is now resized:

   .. code-block:: console

     $ openstack server list
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
     | ID                                   | Name        | Status | Networks                               | Image             | Flavor   |
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
     | 12fe44f6-b9ca-4317-9626-9492a6d348f2 | resize-test | ACTIVE | IPv6=10.2.3.166, 2001:700:2:8201::1010 | GOLD Alma Linux 9 | m1.large |
     +--------------------------------------+-------------+--------+----------------------------------------+-------------------+----------+
