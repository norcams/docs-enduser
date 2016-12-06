.. |date| date::

Known Issues
============

Last changed: |date|

.. contents::

API access
----------

All new users will get a pass phrase to use with API when they provision
a personal project (see :doc:`login`). We do not have any easy way to recrate
the pass phrase at the moment. If you lose yours please contact us.


Only personal projects
----------------------

We currently have a limitation on projects, in which only personal
projects are supported. If you need a project for more general purpose,
please contact us.


Console considerations
----------------------

The instance web console is configured with EN keymapping. This may be
an issue for users with other locales, like NO. If you experience problems
with keymapping (for example, special characthers may map to unexpected keys,
or not at all), change keymapping for your local browser to EN. This is
done differently in different operating systems. Please refer to the
operating system documentation.


Dashboard region selecton
-------------------------

When selecting region and project, use the dropdown menu to the top left
beside the logo. Do not attempt to use the dropdown menu in the upper right
corner.

.. image:: images/dash-regions.png
   :align: center
   :alt: Dashboard region selection


SSH keys different in API and dashboard
---------------------------------------

For now, when uploading SSH keys in dashboard, those keys are not accessable
from the API (and vice versa). Work around this issue by uploading the SSH
keys both in dashboard and via the API.

Limitations on distributed workloads
------------------------------------

Because of resource constraints, it's not possible to order distribution over
multiple compute hosts in the same region. Trying to do so will result in a
"No valid host" error message. A workaround is to distribute workloads over
two regions. These constraints will be lifted as more hardware is deployed in
the IaaS.


Cannot create volume from image
-------------------------------

When attempting to create a volume based on an image (for example, an instance
snapshot), the task will fail. This is a bug in our installation, but considered
to be a corner use case which may be fixed in the future. If you want to launch
an instance based on a snapshot, select launch instance and select "instance 
snapshot" as boot source (which may be what you actually wanted in the first
place).
