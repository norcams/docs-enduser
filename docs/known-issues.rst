.. |date| date::

Known Issues
============

Last changed: |date|

.. contents::

API access
----------

All new users will get a pass phrase to use against the API when they provision
a personal project (see :doc:`login`). There are no means of retrieving this
pass phrase at the moment. Please contact us in case it is lost.


Console considerations
----------------------

The instance web console is configured for EN keymapping. This may be
an issue for users with other locales, like NO. If you experience problems
with keymapping (for instance, special characters may map to unexpected keys,
or not at all), change keymapping for your local browser to EN. This is
done differently in different operating systems. Please refer to the
operating system documentation.


SSH keys different in API and dashboard
---------------------------------------

For now, when uploading SSH keys through the dashboard, those keys are not accessable
from the API (and vice versa). Work around this issue by uploading the SSH
keys both via dashboard and via the API.

Limitations on distributed workloads
------------------------------------

Due to resource constraints, it is not possible to order distribution over
more than two compute hosts in the same region. Trying to do so will result in a
"No valid host" error message. A workaround is to distribute workloads over
two regions. These constraints will be lifted as more hardware is deployed in
the IaaS.


Cannot create volume from image
-------------------------------

When attempting to create a volume based on an image (for example: an instance
snapshot), thcwate task will fail. This is a bug in our installation, but considered
to be a corner use case which may be fixed in the future. If you want to launch
an instance based on a snapshot, select launch instance and then "instance 
snapshot" as boot source (which may be what you actually wanted in the first
place).


Network availability
--------------------

While you control the access to your own virtual machines, the network
access to the infrastructure is limited. To use the dashboard and
access web pages, as well as the API, you are required to use a computer at
your educational institution. Currently this usually implies the wired
network only at the universities and colleges that are authorized for
access.


No access after changed email address
-------------------------------------

Sometimes a user's primary email address changes. This is an issue
due to how Dataporten uses this email address as the user ID, and
thus the user ID and demo/personal projects in UH-IaaS is the same as this
address. The issue might arise when users e.g. changes their status from
student to employee or vice versa. If this situation applies, then please send
an email to support@uh-iaas.no which includes your current and
previous primary email addresses. You will then receive further
instructions on how to proceed.

Resizing an instance
--------------------

Resizing an instance is not an available option in the dropdown menu for now. If you try to resize an instance via API, you will get an "HTTP 403 Forbidden" error. As a workaround, you can create a snapshot of the instance, then edit and resize the snapshot and launch a new instance based on that.

Transferring a volume
---------------------

To transfer a volume from one project to another, both projects have to be within the same region. Please also note that the projects cannot use the same volume simultaneously.

You will experience "Unable to accept volume transfer" error if you try to transfer a volume to a project which is located in another region, or if the project recipient does not have enough quota to accept the volume request.

Creating a snapshot
-------------------

Make sure that the instance is turned off, before creating a snapshot. Creating a snapshot while the instance is running, will disable the network connection.

