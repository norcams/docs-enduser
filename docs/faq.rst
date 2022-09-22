.. |date| date::

Frequently asked questions (FAQ)
================================

Last changed: |date|

.. contents::

Project quotas vs. flavors
--------------------------

Quotas are operational limits. For example, the number of gigabytes allowed for
each project can be controlled so that cloud resources are optimized.
Using the Overview tab on Dashboard will show you the quotas for existing projects.

Flavors define the compute, memory, and storage capacity of computing instances.
It is the size of a virtual machine/instance that can be launched.

Capacity planning and scaling
-----------------------------

Cloud-based applications typically request more discrete hardware
(horizontal scaling) as opposed to traditional applications, which
require larger hardware to scale (vertical scaling).

OpenStack is designed to be horizontally scalable. Rather than switching
to larger servers, you procure more servers and simply install identically
configured services.

- Scalability: possibility to add more virtual machines/instances as needed.

- Flexibility: easier to install, implement and debug.

- Better performance: uptime and live migration.

HTTP 401 Unauthorized Error from the OpenStack API
--------------------------------------------------

.. code-block:: none

  The request you have made requires authentication. (HTTP 401) (Request-ID: req-xxxx-xxxx-xxxx-xxxx-xxxx)

To get access to OpenStack services, you need to have an
authentication token. A token represents the authenticated identity of
your username, password, project, domain, etc.

Each API-request includes a spesific authentication token. To access
multiple services, you need to have a valid token for each service.  A
token can become invalid for different reasons. E.g. if you have wrong
username, password, domain, user role, or lacking proper access to a
project.  Administrative services such as **openstack user, project,
group, domain, etc.** will also give you an unauthorized error.


Transferring a volume
---------------------

To transfer a volume from one project to another, both projects have
to be within the same region. Please also note that the projects
cannot use the same volume simultaneously.

You will experience ``Unable to accept volume transfer`` error if you
try to transfer a volume to a project which is located in another
region, or if the project recipient does not have enough quota to
accept the volume request.


Default OpenStack features disabled in NREC
-------------------------------------------

Some features which are *ON* by default in generic OpenStack, are for
various reasons disabled in NREC. The affected features are listed in the table
below.

.. list-table:: Disabled OpenStack Features
   :header-rows: 1

   * - Feature
     - Description
     - Comment
   * - Reboot
     - Reboot instance
     - Workaround: Shut down and start instance
   * - Resize Instance
     - Make size of instance larger
     - This is disabled in Dashboard (Web GUI).
       Workaround: Use CLI
   * - Suspend
     - Suspend Image and store state on disk
     - Workaround: Pause instance
   * - Shelve
     - Stop instance and free resources whilst retaining state (incl. IP addresses)
     - Workaround: Create snapshot. IP addresses are not retained, though.
   * - Rebuild
     - Rebuild instance, possibly with another image than originally, keeping IP address
     - No workaround! Must delete and build new, with new IP address. This will be fixed.


How to regenerate your public SSH key
-------------------------------------

If your public SSH keys have been mistakenly deleted or disappeared from the
dashboard, and you haven't got local copies, it is trivial to regenerate and
readd them.

Run the following command in your terminal:

.. code-block:: none

  ssh-keygen -y -f <path to your private key>

This will output the public key to stdout which may be stored in a new file or
copied to the clipboard.

To readd a key, go to the NREC Dashboard and click on on
Key Pairs -> Import Public Key

.. only:: comment
   How to rebuild an instance, but preserve the IP addresses
   ---------------------------------------------------------

   By using openstack rebuild function, you can start an instance from a new image
   while maintaining the same IP addresses, amongst other metadata.


   .. code-block:: console

      $ openstack server rebuild --image <image> <server>


Efficiently creating filesystems on large volumes
-------------------------------------------------

XFS/EXT4 formatting on a disk of large size (e.g. several TB) using
mkfs will under normal circumstances take a long time. This is because
mkfs discards (clears) all blocks in the format process. For normal
disks, especially SSD drives, this is what you want. However, due to
the nature of volumes in NREC discarding is not needed. In order to
significantly speed up mkfs, run without discarding:

For XFS::

  mkfs.xfs -K /dev/<device>

For EXT4::

  mkfs.ext4 -E nodiscard /dev/<device>

The time difference is huge for large volumes. Without discarding,
mkfs takes a few seconds compared to several minutes (or hours) with
discarding turned on.


How to acknowledge the use of NREC
----------------------------------

If you have used our infrastructure services for computing or other
needs, we appreciate if you include this in your acknowledgment.

An example of an acknowledgement of having used NREC is:

.. code-block:: none

  The computations were performed on the Norwegian Research and Education
  Cloud (NREC), using resources provided by the University of
  Bergen and the University of Oslo. http://www.nrec.no/


Transferring an instance between projects using snapshot
--------------------------------------------------------

.. _Creating a snapshot: snapshot.html#creating
.. _Downloading a snapshot: snapshot.html#downloading
.. _Uploading a snapshot: snapshot.html#uploading
.. _Launching a snapshot: snapshot.html#launching

While it isn't possible to "move" an instance between different
projects without interruption, you can utilize the snapshot feature to
transfer an instance from one project to another. Note that resources
such as security groups and volumes are not transferred with the
snapshot, and must be reconstructed in the new project.

In order to transfer a workload between projectA and projectB, simply
follow these steps:

#. Take a snapshot of the instance in projectA as descibed here:
   `Creating a snapshot`_

#. Download the snapshot to a local computer: `Downloading a
   snapshot`_

#. Upload the snapshot to projectB: `Uploading a snapshot`_

#. Launch a new instance in projectB using your snapshot as the source
   image: `Launching a snapshot`_

#. Optionally delete the instance and snapshot in projectB if they
   aren't needed anymore.

These steps can be done without deleting the instance in projectA,
i.e. you can verify that all is well in the new instance before
deleting the old instance.

Note that you can't reuse the IP addresses of the old instance when
creating a new in projectB. The new instance will have a different set
of IP addresses. Depending on the application, you may need to
configure either the application itself, the clients, or both.

.. TIP::
   Since downloading a snapshot can only be done using the CLI, we
   recommend doing the whole operation in the CLI rather than using
   the dashboard.


Does NREC block any incoming network traffic?
---------------------------------------------

.. _ACL for Incoming Traffic: acl.html

Yes, certain ports are blocked completely or partially in order to
protect our users and their services running on NREC. More details
here:

* `ACL for Incoming Traffic`_
