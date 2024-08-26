.. |date| date::

Introduction
============

Last changed: |date|

.. contents::

.. _OpenStack: https://www.openstack.org/
.. _OpenStack End User Guide: http://docs.openstack.org/user-guide/index.html
.. _cloud: https://en.wikipedia.org/wiki/Cloud_computing
.. _Infrastructure-as-a-Service: https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29
.. _RESTful: https://en.wikipedia.org/wiki/Representational_state_transfer
.. _OpenStack services: http://www.openstack.org/software/project-navigator
.. _JSON: https://en.wikipedia.org/wiki/JSON
.. _XML: https://en.wikipedia.org/wiki/XML
.. _serialization: https://en.wikipedia.org/wiki/Serialization

About
-----

The NREC cloud_ is based on OpenStack_, which is a large framework
of software components used to deliver an Infrastructure-as-a-Service_
consisting of compute, networking and storage resources.

This document is aimed at the end user. We'll borrow a lot from the
`OpenStack End User Guide`_, including linking to this guide where
appropriate.



*NREC* is a collaboration project between the University of Bergen and
the University of Oslo, with additional sponsorships from NeIC
(Nordic e-Infrastructure Collaboration).
We've been in production since 2016 and are currently providing cloud
infrastructure for several high profile academic projects, including CERN's
ALICE and ATLAS experiments. Our hardware is located exclusively on-premise,
our services are developed locally and we are almost entirely based on Open
Source Software and open standards, making us a more transparent alternative
to commercial cloud providers.

We are a community cloud aiming to provide a modern, flexible and secure IT
infrastucture, tailored to the needs of the research and higher education sector.

Who can use NREC?
------------------------------

.. _Terms of Service: terms-of-service.html
.. _Logging in: login.html
.. _Pricing: pricing.html

.. _The Arctic University of Norway (UiT): https://www.uit.no/
.. _Norwegian University of Life Sciences (NMBU): https://www.nmbu.no/
.. _Norwegian University of Science and Technology (NTNU): https://www.ntnu.no
.. _Sintef: https://www.sintef.no/
.. _UNINETT: https://www.uninett.no/
.. _University of Bergen (UiB): http://www.uib.no/
.. _University of Oslo (UiO): http://www.uio.no/
.. _Norwegian Veterinary Institute: https://www.vetinst.no/



.. IMPORTANT::
   Before using this cloud service, you should familiarize yourself
   with our `Terms of Service`_.

The following educational institutions are allegeable for using NREC.
The requirement is that you have a Feide account from any of these universities or colleges.
NREC is free for UiB and UiO. This includes both private and shared projects.
Other institutions follow a pricing scheme according to `Pricing`_.

+----------------------------------------------------------+---------------------------------+
| University / College / Organization                      | Type of access                  |
+==========================================================+=================================+
| `The Arctic University of Norway (UiT)`_                 | Limited testing                 |
+----------------------------------------------------------+---------------------------------+
| `Norwegian University of Life Sciences (NMBU)`_          | Limited testing                 |
+----------------------------------------------------------+---------------------------------+
| `Norwegian University of Science and Technology (NTNU)`_ | Limited testing                 |
+----------------------------------------------------------+---------------------------------+
| `UNINETT`_                                               | Limited testing                 |
+----------------------------------------------------------+---------------------------------+
| `University of Bergen (UiB)`_                            | Full Access                     |
+----------------------------------------------------------+---------------------------------+
| `University of Oslo (UiO)`_                              | Full Access                     |
+----------------------------------------------------------+---------------------------------+
| `Norwegian Veterinary Institute`_                        | Limited testing                 |
+----------------------------------------------------------+---------------------------------+

Before using the service, you must register with the authentication
mechanism and the service itself. This is explained in detail in
`Logging in`_.


What can you do with NREC?
---------------------------------------

As an OpenStack cloud end user, you can provision your own resources
within the limits set by cloud administrators.

The examples in this guide show you how to perform tasks by using the
following methods:

* OpenStack dashboard. Use this web-based graphical interface to view,
  create, and manage resources.

* OpenStack command-line clients. Each core OpenStack project has a
  command-line client that you can use to run simple commands to view,
  create, and manage resources in a cloud and automate tasks by using
  scripts.

You can modify these examples for your specific use cases.

In addition to these ways of interacting with a cloud, you can access
the OpenStack APIs directly or indirectly through cURL commands or
open SDKs. You can automate access or build tools to manage resources
and services by using the native OpenStack APIs.

To use the OpenStack APIs, it helps to be familiar with HTTP/1.1,
RESTful_ web services, the `OpenStack services`_, and JSON_ or XML_ data
serialization_ formats.


Concepts
--------

Overview
~~~~~~~~

According to standard definitions of cloud computing, there are three
layers:

.. image:: images/Cloud_computing_layers.png
   :align: center
   :alt: Public Domain, https://commons.wikimedia.org/w/index.php?curid=18327835

The NREC cloud provides

* Self service via a web portal to create, manage and delete virtual
  machines.
* Programmable through command line tools and programming language
  libraries.
* Elasticity, in that you can create virtual machines (up to your
  quota) and delete them when they are no longer needed.
* Efficiency by consolidating small virtual machines onto physical
  hardware.

.. image:: images/openstack-software-diagram.png
   :align: center
   :alt: OpenStack overview

OpenStack is an open source cloud computing software, which provides
an efficient pooling of on-demand, self-managed virtual
infrastructure, consumed as a service.


OpenStack components
~~~~~~~~~~~~~~~~~~~~

.. _Nova: http://www.openstack.org/software/releases/rocky/components/nova
.. _Cinder: http://www.openstack.org/software/releases/rocky/components/cinder
.. _Keystone: http://www.openstack.org/software/releases/rocky/components/keystone
.. _Glance: http://www.openstack.org/software/releases/rocky/components/glance
.. _Horizon: http://www.openstack.org/software/releases/rocky/components/horizon
.. _Neutron: http://www.openstack.org/software/releases/rocky/components/neutron

OpenStack is a large framework that consists of an increasingly
growing number of components. The following components are installed
in NREC. Each of the components have a general
description and a code name. The latter is mostly used in development,
but both terms are used interchangeably.

+-----------------------------+-------------------------------------------------+
| Component                   | Description                                     |
+=============================+=================================================+
|Compute (Nova_)              |Manages the lifecycle of compute instances in an |
|                             |OpenStack environment. Responsibilities include  |
|                             |spawning, scheduling and decomissioning of       |
|                             |machines on demand.                              |
+-----------------------------+-------------------------------------------------+
|Block Storage (Cinder_)      |Provides persistent block storage to running     |
|                             |instances. Its pluggable driver architecture     |
|                             |facilitates the creation and management of block |
|                             |storage devices.                                 |
+-----------------------------+-------------------------------------------------+
|Identity service (Keystone_) |Provides an authentication and authorization     |
|                             |service for other OpenStack services. Provides a |
|                             |catalog of endpoints for all OpenStack services. |
+-----------------------------+-------------------------------------------------+
|Image service (Glance_)      |Stores and retrieves virtual machine disk        |
|                             |images. OpenStack Compute makes use of this      |
|                             |during instance provisioning.                    |
+-----------------------------+-------------------------------------------------+
|Dashboard (Horizon_)         |Provides a web-based self-service portal to      |
|                             |interact with underlying OpenStack services, such|
|                             |as launching an instance, assigning IP addresses |
|                             |and configuring access controls.                 |
+-----------------------------+-------------------------------------------------+
|Networking (Neutron_)        |Enables network connectivity as a service for    |
|                             |other OpenStack services, such as OpenStack      |
|                             |Compute. Provides an API for users to define     |
|                             |networks and the attachments into them. Has a    |
|                             |pluggable architecture that supports many popular|
|                             |networking vendors and technologies.             |
+-----------------------------+-------------------------------------------------+


Glossary
~~~~~~~~

**BGO**
  The OpenStack infrastructure located at the University of Bergen (UiB).

**OSL**
  The OpenStack infrastructure located at the University of Oslo (UiO).

**Project**
  A container used to group a set of resources such as virtual
  machines, volumes and images with the same access rights and quota.

**Quota**
  A per-project limit such as the total number of cores or RAM
  permitted for a set of virtual machines.

**Flavor**
  A Flavor is the definition of the size of a virtual machine and its
  characteristics (such as 2 core virtual machine with 8 GB of RAM).

**Image**
  A virtual machine image is a single file that contains a virtual
  disk that has a bootable operating system installed on it. Images
  are used to create virtual machine instances within the cloud.

**Volume**
  Volumes are block storage devices that you attach to instances to
  enable persistent storage. You can attach a volume to a running
  instance or detach a volume and attach it to another instance at any
  time. You can also create a snapshot from or delete a volume.

**Snapshot**
  A snapshot provides a copy of a currently running VM or volume which
  can be stored into an external service such as Glance. A snapshot of a VM is an image.
  To make this distinction, the guide may refer to a snapshot of a VM as a snapshot image.

Conventions
-----------

Notices
~~~~~~~

You may encounter the following notices:

.. NOTE::
   A regular note, usually to explain something in more detail.

.. IMPORTANT::
   An important notice, something you need to be aware of.

.. TIP::
   A practical tip, shortcuts etc.

.. CAUTION::
   Tread carefully, easy to make mistakes..

.. WARNING::
   Warns about something potentially dangerous or destructive.


Command prompts
~~~~~~~~~~~~~~~

A lot of OpenStack interaction is possible by utilizing the command
prompt. When describing something that should be done on the command
line, this text will use the following convention:

.. code-block:: console

  $ command
  Some command output

If the command should be run by the root user, the prompt will instead
be the following:

.. code-block:: console

  # command
  Some command output
