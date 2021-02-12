.. |date| date::

Create and manage snapshots
===========================

.. contents::

You can create a snapshot from an instance, either as a backup, or to
use it as the source image when creating new instances. Either way,
there are a couple of things to consider before creating the snapshot:

* Does the instance have one or more volumes attached? If so, you may
  need to comment out mounts from **/etc/fstab** first, to ensure that
  new instances are able to boot without failures, if using the
  snapshot as a source image for new instances.

* In order to ensure consistency when using the snapshot as a source
  image for new instances, it is always best to shut down the instance
  before taking a snapshot of it.


Create a snapshot
-----------------

Follow these steps to create a snapshot of an instance.

#. In the dashboard, select **Instances** in the **Compute** tab:

   .. image:: images/snapshot-01.png
      :align: center
      :alt: Dashboard - Compute -> Instances

#. Use the drop-down menu and select ``Shut off instance``:

   .. image:: images/snapshot-02.png
      :align: center
      :alt: Dashboard - Compute -> Instances -> shutoff

#. When the instance is shut off, use the drop-down menu and select
   ``Create Snapshot``:

   .. image:: images/snapshot-03.png
      :align: center
      :alt: Dashboard - Compute -> Instances -> create snapshot
   
#. Fill in the **Snapshot Name** and click on ``Create Snapshot`` in
   the window that appears:

   .. image:: images/snapshot-04.png
      :align: center
      :alt: Dashboard - Snapshot Name

The snapshot is now created, and will be located under **Images** in
the **Compute** tab. The image list will be long, use the search field
to enter part of the name of your image and it should appear:

.. image:: images/snapshot-05.png
   :align: center
   :alt: Dashboard - Snapshot Created

.. NOTE::
   Image creation may take a long time. You may need to reload the
   browser page.


   
Downloading the snapshot
------------------------

There could be good reasons to download the snapshot to a local
computer. One reason would be to have an off-site backup of the
instance. Another is to upload the snapshot to another project in
order to use it as a source image for instances in that project.

Downloading a snapshot is not possible via the dashboard, it is only
possible via the CLI or API. The steps needed to download the snapshot
via CLI is detailed below.

#. List images using the option ``--private``, thus excluding official
   NREC images:

   .. code-block:: console

     $ openstack image list --private
     +--------------------------------------+-----------------+--------+
     | ID                                   | Name            | Status |
     +--------------------------------------+-----------------+--------+
     | ada4524b-72f5-4b41-b28e-1ac57c6634a0 | test01-snapshot | active |
     +--------------------------------------+-----------------+--------+

#. Download the image using the image ID. Select a name of the file
   (here: ``test01-snapshot.img``) for the ``--file`` option:

   .. code-block:: console

      $ openstack image save --file test01-snapshot.img ada4524b-72f5-4b41-b28e-1ac57c6634a0
      $ ls -lh test01-snapshot.img 
      -rw-r--r--. 1 user group 10G Feb 11 14:18 test01-snapshot.img


Launch a snapshot
-----------------

Follow the steps outlined in `Create a Linux virtual machine`_. The
only difference is when choosing the image from which to launch the
new instance. Choose ``Instance Snapshot`` as the boot source and your
snapshots should appear. Then choose the preferred snapshot and
proceed as normal:

.. image:: images/snapshot-06.png
   :align: center
   :alt: Dashboard - Compute -> Instances -> launch instance

You can also launch an instance from the **Images** tab. Choose the
snapshot, and click on ``Launch``, and further steps are described
under `Create a Linux virtual machine`_.

The new instance contains now the expected customizations made earlier
in your previous instance.


Deleting a snapshot
-------------------

.. NOTE::
   You can not delete a snapshot that is being used as a source image
   for an instance. If you try to delete a snapshot that is in use as
   a source image, you will get an error:

   .. image:: images/snapshot-07.png
      :align: center
      :alt: Dashboard - Delete Snapshot ERROR

In order to delete a snapshot that no longer need, follow these steps:

#. Navigate to the **Images** tab under **Compute**. The image list
   will be long, use the search field to enter part of the name of
   your image and it should appear:

   .. image:: images/snapshot-05.png
      :align: center
      :alt: Dashboard - Compute -> Images

#. Select ``Delete Image`` to delete the snapshot:

   .. image:: images/snapshot-08.png
      :align: center
      :alt: Dashboard - Compute -> Images -> delete image

You should now get a confirmation that the snapshot is deleted:

.. image:: images/snapshot-09.png
   :align: center
   :alt: Dashboard - Delete Snapshot CONFIRMATION


Uploading a snapshot
--------------------

If you have previously downloaded a snapshot as described in
`Downloading a snapshot`_, you can upload it to a different project or
region. An snapshot is uploaded as an image. In order to upload the
snapshot, navigate to **Images** and click on ``Create Image``:

.. image:: images/snapshot-10.png
   :align: center
   :alt: Dashboard - Compute -> Images -> create image

In the window that appears, you have to specify a name for the image
(here: "my-test-image"), select the file on your computer (here:
"test01-snapshot.img") and select the image format. In our case, and
for previously downloaded snapshots, the image format is "Raw":

.. image:: images/snapshot-11.png
   :align: center
   :alt: Dashboard - Compute -> Images -> image details

You can also set an optional description, and metadata info such as
disk and memory requirements. Click on "Create Image" to proceed. Note
that images and snapshots are large files and uploading may take a
very long time.

After the image has been uploaded, it will appear in the **Images**
tab:

.. image:: images/snapshot-12.png
   :align: center
   :alt: Dashboard - Compute -> Images




	    
Doing the same with CLI
-----------------------

Listing any existing servers:

.. code-block:: console
     
    $ openstack server list
    +--------------------------------------+--------------+--------+---------------------------------------+-----------------------+
    | ID                                   | Name         | Status | Networks                              | Image Name            |
    +--------------------------------------+--------------+--------+---------------------------------------+-----------------------+
    | d281daef-e6b2-4dc5-979b-9c4fcec19b82 | DemoInstance | SHUTOFF| IPv6=2000:200:2:2000::200a, 10.2.0.02 | GOLD Ubuntu 16.04 LTS |
    +--------------------------------------+--------------+--------+---------------------------------------+-----------------------+

Creating snapshot of an existing server:

.. code-block:: console
     
    $ openstack server image create --name DemoInstanceSnapshot DemoInstance  
    +------------------+-----------------------------------------------------------------------------------------------------------------------+
    | Field            | Value                                                                                                                 |
    +------------------+-----------------------------------------------------------------------------------------------------------------------+
    | checksum         | None                                                                                                                  |
    | container_format | None                                                                                                                  |
    | created_at       | 2017-12-20T10:00:23Z                                                                                                  |
    | disk_format      | None                                                                                                                  |
    | file             | /v2/images/f7495bf2-23c3-4b07-b0c4-6da26a0e6b81/file                                                                  |
    | id               | f7495bf2-23c3-4b07-b0c4-6da26a0e6b81                                                                                  |
    | min_disk         | 10                                                                                                                    |
    | min_ram          | 768                                                                                                                   |
    | name             | DemoInstanceSnapshot                                                                                                  |
    | owner            | 1b123d89493123e7937123d91e912304                                                                                      |
    | properties       | base_image_ref='de540652-bb5f-4827-8abc-6a17cfc37790', hw_disk_bus='scsi', hw_scsi_model='virtio-scsi',               |
    |                  | image_type='snapshot', instance_uuid='d281daef-e6b2-4dc5-979b-9c4fcec19b82', locations='[]',                          |
    |                  | user_id='57c5e7b739614845811d123227a6d596'                                                                            |
    | protected        | False                                                                                                                 |
    | schema           | /v2/schemas/image                                                                                                     |
    | size             | None                                                                                                                  |
    | status           | queued                                                                                                                |
    | tags             |                                                                                                                       |
    | updated_at       | 2017-12-20T10:00:23Z                                                                                                  |
    | virtual_size     | None                                                                                                                  |
    | visibility       | private                                                                                                               |
    +------------------+-----------------------------------------------------------------------------------------------------------------------+

Listing available images:
  
.. code-block:: console
     
    $ openstack image list
    +--------------------------------------+-----------------------------------+-------------+
    | ID                                   | Name                              | Status      |
    +--------------------------------------+-----------------------------------+-------------+
    | 20cc80f4-1567-4082-ac6f-68c9ae2040ff | myInstanceSnapshot                | active      |
    +--------------------------------------+-----------------------------------+-------------+
   
