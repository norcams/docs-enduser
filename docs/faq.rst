.. |date| date::

Frequently asked questions (FAQ)
================================

Last changed: |date|

.. contents::

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


Resizing an instance
--------------------

Resizing an instance is not an available option in the dropdown menu
for now. If you try to resize an instance via API, you will get an
``HTTP 403 Forbidden`` error. As a workaround, you can create a snapshot
of the instance, then edit and resize the snapshot and launch a new
instance based on that.


How to acknowledge the use of NREC
-------------------------------------

If you have used our infrastructure services for computing or other
needs, we appreciate if you include this in your acknowledgment.

An example of an acknowledgement of having used NREC is:

.. code-block:: none

  The computations were performed on the Norwegian Research and Education
  Cloud (NREC), using resources provided by the University of
  Bergen and the University of Oslo. http://www.nrec.no/

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

Project quotas vs. flavors
--------------------------

Quotas are operational limits. For example, the number of gigabytes allowed for
each project can be controlled so that cloud resources are optimized.
Using the Overview tab on Dashboard will show you the quotas for existing projects.

Flavors define the compute, memory, and storage capacity of computing instances.
It is the size of a virtual machine/instance that can be launched.
