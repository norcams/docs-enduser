.. |date| date::

Troubleshoot
============

Last changed: |date|

.. contents::

No connection initially after the instance is set up and started
----------------------------------------------------------------

Sometimes whan a new instance is created it is not possible to get a connection
to it, neither using `ssh` nor `ping` (icmp). Especially the very first time one
is trying out the NREC service, some parts may be confusing. Here are a couple
of steps one might use to try to remedy the situation and/or get a better
understanding of the basic network concepts.


Private IPv4 / Instance using the 'IPv6' network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When one defines the new instance, there is a choice between several networks:
*IPv6* and *dualStack*. The names are not strictly accurate, and the differences
can be described thus:

+--------------+-------------------------+---------------+
| Network name |  IPv4                   | IPv6          |
+==============+=========================+===============+
| IPv6         | Private IPv4 address    | Public IPv6   |
|              | in the 10.0.0.0/8 range |               |
+--------------+-------------------------+---------------+
| dualStack    | Public IPv4             | Public IPv6   |
+--------------+-------------------------+---------------+

As can be seen from this table, both cases yields both an IPv4 and an IPv6
address. But note that the IPv4 address assigned in the `IPv6` case is a *private* address (so
called *RFC1918 address*) which is not reachable from outside the project!
If the instance is using the `IPv6` network, then you **must** use IPv6 to get
to it! The IPv4 address is NOT reachable from your own machine. If you try
accessing your new instance on an address starting with '10', then this is the
reason for not getting any response.

**Solution**: Use its IPv6 address for connection


No connection using IPv6
~~~~~~~~~~~~~~~~~~~~~~~~

Your instance is always assigned an IPv6 address. If you try to get a conenction to the
instance using this address, and you get *No route to host* or otherwise no
response, then verify that you have a proper IPv6 address on the system you
connect from.

.. Note::
   If the only IPv6 address you have is something which starts with `fe80` - and no other
   IPv6 address, then you just have the so called *link-local* address. This is
   NOT a public IPv6 one, and usually this address is not suitable for
   traffic to anything beyond your local network.

**Solution**: Check your assigned IPv6 address, and if none assigned or just
assigned a `link-local`, then either go through a IPv6 enabled host ( like
*login.uib.no* or *login.uio.no* ) or switch to IPv4 (and then make sure your instance
is using `dualStack`, as descibed in the previous section).


Still no connection
~~~~~~~~~~~~~~~~~~~

Every instance is implicitly attached a firewall, which by default only let
traffic from instances in the same project through. All traffic from the outside
is blocked! To connect to your instance, whether through `ssh`, `ping` (icmp),
`RDP` or something else; your instance firewall must be configured to let it
pass. If you are sure you have the addressing right (using public addresses for
the instance and have everything set up properly on the local side), then it may
be an idea to have a look at the firewall - or *Security groups*, as it is
called.

.. Note::
   In the context of security rules, the *Remote* address is seen from the view
   point of the instance, not your location.
   When you add rules, make sure the *Remote* address entered is the address(es)
   of the system *you are coming from*. If you are going through a jumphost,
   then it is the address of the latter which should be entered.

**Solution**: Make sure the rules in your security group are appropriate. If
unsure if it is the remote address in the rules which blocks you, a temporary
fix is to use `0.0.0.0/0` (for IPv4) or `::0/0` (for IPv6) to open up the
specific protocol for the whole Internet. But please make sure to tighten this
up when your debugging session is over!



Lost access to instance
-----------------------
.. _lostaccess:

There can be multiple reasons for losing access to an instance.

- Lost SSH key
- Disk trouble e.g. wrong mount path (`Rescue instance`_)
- Problems with NIC/network (`Rescue instance`_)

Don't fret, there is maybe a way (workaround) to fix this by accsessing the console/terminal.
But you need to do some "hacks" to do so if you didn't set/change a users password.


Possible solution (workaround [#f1]_)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Got to console, press the "Send ctrlAltDel" button then activate the console window and interrupt the boot by pressing an arrow key for example. Choose a boot entry and press :kbd:`e` for edit.
Depending on which OS is in use you can edit the boot loader in the console and boot to single user by adding single to the end of the line that start with linux on ubuntu, on centos you have to remove all ``console=ttys`` besides the ``tty0`` and add ``rd.break enforcing=0`` at the end of the line starting with linux16.
There a several exampels and documentation on how to start your Linux server/instance in singel mode (root access) which you can find by searching the web. On centos you have to be fast to interrupt the normal boot.
Depending on if you are using Ubuntu or Centos you should now have a console and logged in as root. The keyboard layout is probably en_US.UTF8 which means you have to figure out what keys on your keyboard represent :kbd:`=`, :kbd:`/`, :kbd:`-` and :kbd:`:` etc.

On my keyboard (norwegian):

:kbd:`=` is :kbd:`\\` left key from backspace

:kbd:`/` is :kbd:`-` left key from right shift

:kbd:`-` is :kbd:`?` second left key from backspace

:kbd:`:` is :kbd:`shift` + :kbd:`ø`

Now you can issue a password change for e.g. the root account by running `passwd` or `passwd username`.
If you are using Centos you have to do some additional steps as follows.
You need to mount :file:`/sysroot` by running `mount -o remount,rw /sysroot` and then change root by running `chroot /sysroot`.
Now you can run e.g `passwd`
After you've don that, reboot and log in to console again on normal boot.
Now you can fix the authorized_keys. I fetched my public ssh keys from github.

E.g
``wget https://github.com/username.keys``
or
``curl -o pub.keys https://github.com/username.keys``

Then add or replace the keys in authorized_keys

E.g
``cat username.keys >> authorized_keys``

The authorized_keys file is located in :file:`/home/username/.ssh/authorized_keys`
Now you should be able to login using ssh with the new key(s).

.. NOTE::
   If you are experiencing problem with booting up and you have attached
   volumes(s), try dettach them first then run rescue agian.


----------

Rescue instance
---------------
.. _rescue mode: https://docs.openstack.org/nova/latest/user/rescue.html


Here is a quick runddown on how it is done using the dashboard.

For more information, take a look at the Openstack documentation on `rescue mode`_


.. NOTE::
   Setting a password when activating rescue mode dose not work.
   If you lost access to the SSH key take a look at lostaccess_

Using the dashboard
~~~~~~~~~~~~~~~~~~~
.. _security groups: https://docs.nrec.no/security-groups.html#id3

.. image:: images/rescue-instance-01.png
   :align: center
   :alt: Start rescue mode form dashboard

.. image:: images/rescue-instance-02.png
   :align: center
   :alt: Start rescue mode form dashboard

.. image:: images/rescue-instance-03.png
   :align: center
   :alt: Start rescue mode form dashboard

If you need to edit `security groups`_ then edit instance and then select "Security Groups".

.. image:: images/rescue-instance-04.png
   :align: center
   :alt: Start rescue mode form dashboard

.. image:: images/rescue-instance-05.png
   :align: center
   :alt: Unrescue instance form dashboard

To SSH to the rescued instance, you may need to delete the key-fingerprint to the original instance

ssh-keygen -f ~/.ssh/known_hosts -R <INSTANCE-IP>'

You should then be able to SSH into the rescued instance using the default username, as listed in https://docs.nrec.no/gold-image.html#id14

.. NOTE::
   (Linux) Volume UUID with different images

   If you do not select the same GOLD image as the one the instance
   originally used, the two (pseudo)disks may end
   up with the same UUID. For some distributions this may cause the instance to
   mount its root filesystem from the damaged disk. The upshot is that any SSH
   connections will seemingly connect to the broken instance, and the rescue
   attempt is thus moot.

   The workaround is to explicitly specify an image for the rescue attempt, and
   select any other image than the one used for setting up the instance in the
   first place.


Not able to SSH to Debian instance created from uploaded snapshot image
-----------------------------------------------------------------------
.. _debianimagenetwork:

Description
~~~~~~~~~~~

I created an instance based on a Debian image that I downloaded
before. The image was created from a snapshot of a Debian instance. I
am not able to SSH to the new instance.

Possible solution
~~~~~~~~~~~~~~~~~

When an image snapshot is downloaded from a project;

.. code-block:: console

  openstack image save --file <image name>.img <image ID>

it does not save its properties from OpenStack.

These image properties can be seen using the OpenStack API. They are
only set for pre-existing images and snapshots in a project:

.. code-block:: console

  openstack image show <image ID> -c properties -f yaml

Unfortunately, when a new instance is created based on the .img file,
these properties are not set. For Debian instances, lack of these
properties imposes hardware change that leads to a different naming of
the network interface card (NIC). Since the old NIC name is specified
in existing network configuration files, the newly created instance
will not receive a network connection.

The solution is to set the correct properties of the uploaded
image. The properties that need to be set in order for the image to
perform optimally can be found in our image repository [#f2]_. Look
for the gold image that best matches your image, and set each property
with the following command:

.. code-block:: console

  openstack image set --property <name>=<value> <image ID>

Example:

.. code-block:: console

  openstack image set --property hw_machine_type=q35 <image ID>

Specifically, for a Debian 12 instance, the properties that
needs to be set are specified in our image repository [#f2]_ under
'debian12'::'properties' and is a subset of the properties seen with
the ``openstack image show`` command above.

.. code-block:: none

  $ while read line; do k=$(echo $line | cut -d ' ' -f 1); v=$(echo $line | cut -d ' ' -f 2); cmd="openstack image set --property $k=$v <image ID>"; eval $cmd; done <<< 'hw_disk_bus scsi
       hw_scsi_model virtio-scsi
       hw_rng_model virtio
       hw_qemu_guest_agent yes
       hw_machine_type q35
       hw_firmware_type uefi
       hw_vif_multiqueue_enabled yes
       os_require_quiesce yes
       os_type linux'

----------------------------------------------------------------------

.. rubric:: Footnotes

.. [#f1] Since setting a password when rescuing an instance do not work.

.. [#f2] https://github.com/norcams/himlarcli/blob/master/config/images/default.yaml
