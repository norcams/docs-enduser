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

Booting instance from a volume
------------------------------

Booting instances from volumes is an experimental feature. Several features do not
work when the instance is bootet from a volume: If you create a snapshot of the
instance, the snapshot will not be bootable. You can, however, turn off the instance and
create a volume snapshot of the bootdisk. Also, it is not possible to attach
another volume to the instance. These constrains should be fixed in future upgrades.


Network availability
--------------------

To use the access web page you are required to use a computer at your educational
institution.  Currently this usually implies the wired network only at the universitie
and colleges that are authorized for access.


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


Outdated size
-------------
.. _flavors: http://docs.uh-iaas.no/en/latest/changelog.html#id1

As we have updated flavors_, the users that have had access to the larger machines may now notice new size status "Outdated" on the Horizon dashboard. Those flavors are not available anymore, but it will not affect the running instances.

