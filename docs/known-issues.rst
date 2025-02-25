.. |Y| unicode:: U+2714
.. |N| unicode:: U+2716
.. |W| unicode:: U+26A0

Known Issues
============

.. contents::

Debian 12 instance loses network connectivity
---------------------------------------------

We have had issues with GOLD Debian 12 images created before January
2025, where the instance loses network connectivity. If this applies
to you, here is how you fix it.

Verification
~~~~~~~~~~~~

First, make sure that the missing network connectivity is not due to
missing or wrong security group rules. You can also verify that this
bug applies to your instance by running

.. code-block:: text

   openstack console log show <server>

If the output contains this, your instance is affected by this bug:

.. code-block:: text

   Cloud-init v. 22.4.2 running 'init' at Tue, 25 Feb 2025 12:49:19 +0000. Up 128.85 seconds.
   ci-info: +++++++++++++++++++++++++++Net device info++++++++++++++++++++++++++++
   ci-info: +--------+-------+-----------+-----------+-------+-------------------+
   ci-info: | Device |   Up  |  Address  |    Mask   | Scope |     Hw-Address    |
   ci-info: +--------+-------+-----------+-----------+-------+-------------------+
   ci-info: | enp3s0 | False |     .     |     .     |   .   | fa:16:3e:9a:4e:de |
   ci-info: |   lo   |  True | 127.0.0.1 | 255.0.0.0 |  host |         .         |
   ci-info: |   lo   |  True |  ::1/128  |     .     |  host |         .         |
   ci-info: +--------+-------+-----------+-----------+-------+-------------------+
   ci-info: +++++++++++++++++++Route IPv6 info+++++++++++++++++++
   ci-info: +-------+-------------+---------+-----------+-------+
   ci-info: | Route | Destination | Gateway | Interface | Flags |
   ci-info: +-------+-------------+---------+-----------+-------+
   ci-info: +-------+-------------+---------+-----------+-------+

In the output above, we see that the network device ``enp3s0`` does
not receive IP addresses and the routing table is empty.

How to fix
~~~~~~~~~~

Follow these steps to fix the issue:

#. We have a Debian 12 instance that has no network connectivity:

   .. figure:: images/debian12-failed-image-01.png
      :align: center
      :alt: Failed Debian 12 instance

#. Select **Rescue Instance** in the drop-down menu:

   .. figure:: images/debian12-failed-image-02.png
      :align: center
      :alt: Rescue Instance
   
#. Select **GOLD Debian 12** as the rescue image and click **Confirm**:

   .. figure:: images/debian12-failed-image-03.png
      :align: center
      :alt: Rescue Image

#. The instance will now boot into rescue mode, using the image you
   selected as base. Log into the instance via ssh:

   .. code-block:: console

      $ ssh -l debian 2001:700:2:8301::129d
      ...
      debian@deb12-fail:~$ 

#. Become root:

   .. code-block:: console

      debian@deb12-fail:~$ sudo -i
      root@deb12-fail:~# 

#. Create a mount point for the original image:

   .. code-block:: console

      root@deb12-fail:~# mkdir /rescue

#. Mount the original image:

   .. code-block:: console

      root@deb12-fail:~# mount /dev/sdb1 /rescue

#. Replace the file ``custom-networking.cfg`` with the the one from the
   rescue image:

   .. code-block:: console

      root@deb12-fail:~# cp /etc/cloud/cloud.cfg.d/custom-networking.cfg /rescue/etc/cloud/cloud.cfg.d/

#. Remove contents of ``/rescue/var/lib/cloud`` to make cloud-init
   being re-run at next boot:

   .. code-block:: console

      root@deb12-fail:~# rm -rf /rescue/var/lib/cloud/*
      
#. Unmount the original image:

   .. code-block:: console

      root@deb12-fail:~# umount /rescue

#. Log out from the rescue instance, go back to the dashboard and
   select **Unrescue Instance**:

   .. figure:: images/debian12-failed-image-04.png
      :align: center
      :alt: Unrescue Instance

That is all. The Debian 12 instance will now boot with the changes we
made, and networking should work.

Note that since we re-ran the entire cloud-init things like ssh host
keys will have changed.


SSH keys with Windows instances
-------------------------------

There are certain limitations regarding using various types of SSH
keys with Windows instances. While all normal SSH keys work while
simply connecting to an instance, there are limitations to consider if
you want to use the SSH key to retrieve the Admin password.

+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+
| Key                         | Connecting | Retrieve password in CLI | Retrieve password in GUI | How to create key                   |
+=============================+============+==========================+==========================+=====================================+
| ed25519                     | |Y|        | |N|                      | |N|                      | ``ssh-keygen -t ed25519``           |
+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+
| ecdsa                       | |Y|        | |N|                      | |N|                      | ``ssh-keygen -t ecdsa``             |
+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+
| rsa (regular)               | |Y|        | |N|                      | |N|                      | ``sh-keygen -t rsa -b 4096``        |
+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+
| rsa (PEM with passphase)    | |Y|        | |Y|                      | |N|                      | ``sh-keygen -t rsa -b 4096 -m PEM`` |
+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+
| rsa (PEM without passphase) | |Y|        | |Y|                      | |Y|                      | ``sh-keygen -t rsa -b 4096 -m PEM`` |
+-----------------------------+------------+--------------------------+--------------------------+-------------------------------------+

We have the following recommendations for SSH keys:

* You should always, if possible, protect your SSH key with a strong
  passphrase

* **ed25519** is the strongest type overall. Use this if you don't
  have a reason to use something else (e.g. retrieve Admin password on
  Windows)

* **ecdsa** is OK, but there is no reason to use this over ed25519

* **RSA** is OK but is getting old. We think that it's probably just a
  matter of time before RSA becomes obsolete and considered insecure


(Jan 2023) New vGPU licenses in OSL
-----------------------------------

New NVIDIA Compute licenses have been issued in the OSL region. We are
transitioning to a new licensing setup as the previous scheme will be
end of life in July 2023. The old licenses are expired. New licensing
implies new license servers with slightly different configuration, and
the configuration resides in the instances. In order to use the new
licenses in OSL, issue the following command from the instance::

  sudo curl https://download.iaas.uio.no/nrec/nrec-resources/files/nvidia-vgpu/jan-2023-osl-fix.sh | bash

Note that this URL is only accessible from NREC IP ranges. You should
always be vary of piping stuff from URLs directly into bash as
root. In order to just display what would be done when running the
command above, run the command without piping to bash, i.e.::

  curl https://download.iaas.uio.no/nrec/nrec-resources/files/nvidia-vgpu/jan-2023-osl-fix.sh

After running the command, you should see that the vGPU is licensed::

  $ nvidia-smi -q | grep -A2 'vGPU Software Licensed Product'
      vGPU Software Licensed Product
          Product Name                      : NVIDIA Virtual Compute Server
          License Status                    : Licensed (Expiry: 2023-1-31 11:32:22 GMT)

Note that this is only needed for existing instances. New GOLD images
issued February 1 2023 will come preconfigured with new licenses.


CentOS 8 downstream end-of-life December 31, 2021
-------------------------------------------------

A policy change from the CentOS team changed the end-of-life date from 2029 to
the end of 2021, instead shifting focus to the CentOS Stream distribution. The
difference being that Stream is an upstream release for RedHat Enterprise Linux (RHEL),
as opposed to a downstream distribution as it has been hitherto. The Stream
distribution will release packages one minor release ahead of RedHat Enterprise Linux,
and for some this represents a stability consern. This has prompted a community
response in the form of two new downstream RHEL distributions, Alma Linux and Rocky
Linux.

The NREC Team now provides GOLD images for Alma Linux, Rocky Linux, and CentOS Stream 8.
Existing CentOS 8 instances can easily be converted to either mentioned distributions,
or you can create new instances. The NREC team will provide more information on how to
proceed in due time when CentOS 8 reaches end of life.

Please refer to :doc:`gold-image` for more information on available GOLD images.

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
.. _here: http://docs.nrec.no/powercycle.html

We've recently made some changes to the console which requires you to reboot
your instance. Note that you'll have to power cycle from within Openstack, soft
rebooting doesn't help. We've made a short guide on how to do that here_

SSH keys different in API and dashboard
---------------------------------------

For now, when uploading SSH keys through the dashboard, those keys are not accessable
from the API (and vice versa). Work around this issue by uploading the SSH
keys both via dashboard and via the API.

Booting instance from a volume
------------------------------

Booting instances from volumes is an experimental feature. Several features do not
work when the instance is bootet from a volume: If you create a snapshot of the
instance, the snapshot will not be bootable. You can, however, turn off the instance and
create a volume snapshot of the bootdisk. Also, it is not possible to attach
another volume to the instance. These constrains should be fixed in future upgrades.

Maximum number of volume attachments to an instance
---------------------------------------------------

Currently a bug in the upstream software stack used in our service prevents more
than six volume attachments to a single instance. When a user try to attach more volumes
than six, the attempt will silently fail.

Network availability
--------------------

To use the access web page you are required to use a computer at your educational
institution.  Currently this usually implies the wired network only at the universities
and colleges that are authorized for access.


No access after changed email address
-------------------------------------

Sometimes a user's primary email address changes. This is an issue
due to how Dataporten uses this email address as the user ID, and
thus the user ID and demo/personal projects in NREC is the same as this
address. The issue might arise when users e.g. changes their status from
student to employee or vice versa. If this situation applies, then please send
an email to support@nrec.no which includes your current and
previous primary email addresses. You will then receive further
instructions on how to proceed.


Outdated size
-------------
.. _flavors: http://docs.nrec.no/changelog.html#id1

As we have updated flavors_, the users that have had access to the larger machines may now notice new size status "Outdated" on the Horizon dashboard. Those flavors are not available anymore, but it will not affect the running instances.


Missing network when provisioning from snapshot
-----------------------------------------------

Debian 9, 10
''''''''''''

IPv6 is broken in an instance started from a snapshot, and this can also affect
the original instance. If the resolver addresses is configured using their IPv6
addresses, even IPv4 is affected. This issue appears regardless of which network
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


Web GUI does not list all records or zones if more than 20 is defines
---------------------------------------------------------------------
There is a bug in our version of OpenStack Horizon (the Web GUI) where it does
not list more than 20 records or zones. No indication of this is present.
Workaround: Use CLI.


Instance name
-------------
We recommend you to name your instances only with [a-zA-Z0-9]
characters to avoid any maintenance issues.


Security Groups caution
-----------------------
When creating security groups via the API (e.g. Terraform), be as explicit as
possible when setting parameters. In one case we discovered that opening a port
range for all IPs without explicitly setting 0.0.0.0/0 for the remote-ip
parameter (which is default) opened all ports for all IPs. We routinely report
bugs to Openstack developers, however, this is how to work around the problem
for now.

Security group rules created in the dashboard are not affected by this bug,
however, make sure your CIDR notation is correct and make sense to avoid having
Openstack correcting it by guessing what your intentions are. Use a CIDR
calculator if you're unsure.

Users are always advised to ensure their security group rules work as intended
in regards to both IP and port filtering.

Security Groups rule description
--------------------------------

It is not possbile to add description to a security group rule due to
a bug. This will hoepfully be fixed in future upgrades.

Can choose both IPv6 and dualStack
----------------------------------

.. _IPv6 or dualStack: networking.html#ipv6-or-dualstack

It is possible, when creating an instance, to select more than one
network on a single host. As described in `IPv6 or dualStack`_ you
should only select one network.

If an instance has more than one network enabled, it will most likely
not work correctly. In order to fix this issue, do the following:

#. Shut down the instance

#. In the GUI, select **Detach Interface** and select the network you
   wish to remove

#. Start the instance

It may take a few minutes for the instance to become available with
the fixed networking setup.


GOLD image may vary between regions
-----------------------------------

As our GOLD images are built separately for each region, and not necessarily on
the same day, the base upstream image may be altered between the builds. Thus
there may be some differencies between instances started at the same time in our
two regions, even though they may seem to be started from the same GOLD image.

