.. |date| date::

Frequently asked questions (FAQ)
================================

Last changed: |date|

.. contents::

HTTP 401 Unauthorized Error from the OpenStack API
--------------------------------------------------

::

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

You will experience `Unable to accept volume transfer` error if you
try to transfer a volume to a project which is located in another
region, or if the project recipient does not have enough quota to
accept the volume request.


Resizing an instance
--------------------

Resizing an instance is not an available option in the dropdown menu
for now. If you try to resize an instance via API, you will get an
`HTTP 403 Forbidden` error. As a workaround, you can create a snapshot
of the instance, then edit and resize the snapshot and launch a new
instance based on that.


How to acknowledge the use of UH-IaaS
-------------------------------------

If you have used our infrastructure services for computing or other
needs, we appreciate if you include this in your acknowledgment.

An example of an acknowledgement of having used UH-IaaS is::

  This work was performed on the UH-IaaS infrastructure cloud, owned
  by the University of Oslo and University of Bergen, and co-operated
  by their respective IT departments. http://www.uh-iaas.no/

If you publish a paper where we, or rather one or more of us, are
co-authors, please contact us for the correct author information.
