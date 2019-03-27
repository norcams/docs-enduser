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

Console doesn't appear
----------------------
.. _here: http://docs.uh-iaas.no/en/latest/powercycle.html

We've recently made some changes to the console which requires you to reboot
your instance. Note that you'll have to power cycle from within Openstack, soft
rebooting doesn't help. We've made a short guide on how to do that here_

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


Missing network when provisioning from snapshot
-----------------------------------------------

Debian 9
''''''''

IPv6 is broken in an instance started from a snapshot, and this ccan also affect
the original instance. If the resolver addresses is configured using their ipv6
addresses, even ipv4 is affected. This issue appears regardless of which network
is selected for the instance. Here is a workaround:

1. Log in to the instance as the **debian** user

#. Remove the IPv6 dhclient leases file::

     rm /var/lib/dhcp/dhclient6.eth0.leases

#. Log out and shut down the system

#. Create a snapshot

#. The original instance might be restarted at this point

You should now be able to create new machines based upon this snapshot and get
fully functional networks.


CentOS 7
''''''''

.. NOTE::
   This issue only affects CentOS 7 instances provisioned from our
   GOLD image before 2019-01-01. As of January 1, 2019 the GOLD image
   for CentOS 7 is upgraded to CentOS 7.6, and the networking setup
   has been fixed.

There is an issue with CentOS and provisioning instances from a
snapshot. This is due to a local workaround we have added to mitigate
a bug in the CentOS cloud-init package. This bug is fixed in CentOS
7.6 onwards. However, for instances originally provisioned with CentOS
7.5 or older this is a problem. Here is how to fix this:

#. Log in to your instance as the **centos** user

#. Make sure that the instance is fully updated::

     sudo yum upgrade -y

#. Make sure that the instance is running at least CentOS 7.6
   (example)::

     [centos@centos ~]$ cat /etc/centos-release
     CentOS Linux release 7.6.1810 (Core)

#. Install the **NetworkManager** package::

     sudo yum -y install NetworkManager

#. Enable the **NetworkManager** service::

     sudo systemctl enable NetworkManager

#. Remove the file
   ``/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg``::

     sudo rm /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

#. Create a file ``/etc/cloud/cloud.cfg.d/custom-networking.cfg``
   with the following contents::

     network:
       version: 2
       ethernets:
         eth0:
           dhcp4: true
           dhcp6: true

After this change, you should be able to take a snapshot from the
instance, and use that snapshot to provision other
instances. Networking should just work. Note that we have introduced a
significant change to the original instance. This instance should be
rebooted after the changes, if possible.


Cannot delete DNS zones or records in dashboard
-----------------------------------------------

.. _Deleting records in CLI: dns.html#id7
.. _Deleting a zone in CLI: dns.html#id8

Currently, the GUI module for the DNS service has a Javascript bug
which prevents deletion of zones and records from the GUI. Preliminary
testing suggests that thus bug is fixed in the next release of
Openstack (the "Rocky" release). An upgrade to the "Rocky" release is
planned later this year. For now, zones and records can be deleted
using the API, for example via the command line (CLI):

* `Deleting records in CLI`_
* `Deleting a zone in CLI`_
