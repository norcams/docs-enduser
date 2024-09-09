.. |date| date::

Upload and manage images
========================

Last changed: |date|

.. contents::

Instead of using our GOLD images, you may create an image directly by uploading your own cloud image in raw or QCOW2 format. This may be used as the base for your instances.

Upload an image
---------------

#. Log in to the dashboard

#. Select the appropriate project from the drop down menu at the top left

#. On the Project tab -> Compute tab ->  Images category

#. Click Create Image

#. The Create An Image dialog box appears

#. Enter the following values:

   .. code-block:: console

    +-------------------+----------------------------------------------------------------------+
    | Image Name        | Enter a name for the image                                           |
    | Image Description | Enter a description of the image                                     |
    | Image Source      | Browse the image source                                              |
    | Format            | Select the image format (E.g. QCOW2) for the image                   |
    | Architecture      | Specify the architecture. E.g. i386 for a 32-bit/x86_64 for a 64-bit |
    | Minimum Disk (GB) | Leave this field empty                                               |
    | Minimum RAM (MB)  | Leave this field empty                                               |
    | Protected         | Select if only users with permissions can delete the image - Yes/No  |
    +-------------------+----------------------------------------------------------------------+


Doing the same with CLI
-----------------------

The simplest way to obtain a virtual machine image that works with OpenStack is to download one of offical
images. 
We recommend using the images in qcow2 format.

.. code-block:: console

    $ openstack image create --disk-format qcow2 --public --file ./cirros-x86_64-disk.img DemoImage

.. code-block:: console

    $ openstack image list
    +--------------------------------------+---------------------+-------------+
    | ID                                   | Name                | Status      |
    +--------------------------------------+---------------------+-------------+
    | 6520eb21-09b6-4745-d905-7779ac579af8 | DemoImage           | active      |
    | cbd76177-c79b-490f-9a7f-59f9eed3412e | Debian Jessie 8     | active      |
    | d175564a-156e-41c7-b2a3-fd8b018e9e11 | Outdated (Ubuntu)   | deactivated |
    | 484e5754-f4f7-409c-8ba1-454e422816b4 | Outdated (Ubuntu)   | deactivated |
    | fecf1f4d-e36d-44fe-94de-4eae707b40aa | Outdated (Ubuntu)   | deactivated |
    | 6f24613b-4f98-4caa-9bc6-0294f4c67fac | Outdated (Fedora)   | deactivated |
    | ceb6ff80-24de-460a-9ecc-85f3283aa98e | Outdated (Debian)   | deactivated |
    | d241a2b5-cd1d-4812-8d59-2ccfb1acbf88 | CentOS 7            | active      |
    +--------------------------------------+---------------------+-------------+

Useful image properties
-----------------------

When uploading custom images, there are a couple of properties you can set that
provide additional benefits, more than 28 drives to a vm, different topology, larger than
2TB boot volumes, etc. The ones we recommend setting are;

.. code-block::

    hw_disk_bus: scsi
    hw_scsi_model: virtio-scsi
    hw_qemu_guest_agent: yes

You can set these whilst creating the image by using the
``--property key=value`` parameter like so;

.. code-block:: console

   $ openstack image create --disk-format qcow2 --file fedora-coreos-34.20210919.3.0-openstack.x86_64.qcow2 \
         --property hw_disk_bus=scsi --property hw_scsi_model=virtio-scsi --property hw_qemu_guest_agent=yes \
         fedora-coreos-34.20210919.3.0-openstack.x86_64

You can also set or alter properties on an existing image using the same
``--property key=value`` parameter like this;

.. code-block:: console

   $ openstack image set --property hw_machine_type=q35 --property hw_video_model=virtio cirros-0.5.2-x86_64-disk

Below are some additional properties you can experiment with, mind you that not
all images support all properties. Their default values are on the left,
suggested values to the right. ``hw_machine_type`` is finicky on older images.
``hw_firmware_type`` will currently only work on images that support secureboot.

.. code-block::

    +--------------------------------------------+
    | Property            | Default  | Suggested |
    +---------------------+----------+-----------+
    | hw_machine_type:    | pc       | q35       |
    | hw_firmware_type:   | bios     | uefi      |
    | hw_video_model:     | cirrus   | virtio    |
    | hw_watchdog_action: | disabled | reset     |
    +--------------------------------------------+

You can read more about image properties here; https://docs.openstack.org/glance/latest/admin/useful-image-properties.html
