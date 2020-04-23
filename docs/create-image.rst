.. |date| date::

Upload and manage images
========================

Last changed: |date|

.. contents::

You can create an image and use it as the base for your instances.

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

