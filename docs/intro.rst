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

The UH-IaaS cloud_ is based on OpenStack_, which is a large framework
of software components used to deliver an Infrastructure-as-a-Service_
consisting of compute, networking and storage resources.

This document is aimed at the end user. We'll borrow a lot from the
`OpenStack End User Guide`_, including linking to this guide where
appropriate.


Who can use the UH-IaaS cloud?
------------------------------

.. _Terms of Service: terms-of-service.html
.. _Logging in: login.html

.. _University of Bergen (UiB): http://www.uib.no/
.. _University of Oslo (UiO): http://www.uio.no/
.. _UNINETT: https://www.uninett.no/
.. _University of Agder (UiA): http://www.uia.no/

.. IMPORTANT::
   Before using this cloud service, you should familiarize yourself
   with our `Terms of Service`_.

All users at educational institutions that are allegeable for access
can use the UH-IaaS cloud. All you need is an account any of these
universities or colleges.

+--------------------------------+---------------------------------+
| University / College           | Type of access                  |
+================================+=================================+
| `University of Bergen (UiB)`_  | Full Access                     |
+--------------------------------+---------------------------------+
| `University of Oslo (UiO)`_    | Full Access                     |
+--------------------------------+---------------------------------+
| `UNINETT`_                     | Limited testing                 |
+--------------------------------+---------------------------------+
| `University of Agder (UiA)`_   | Full Access                     |
+--------------------------------+---------------------------------+

Before using the service, you must register with the authentication
mechanism and the service itself. This is explained in detail in
`Logging in`_.


What can you do with the UH-IaaS cloud?
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

The UH-IaaS cloud provides

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

.. _Nova: http://www.openstack.org/software/releases/mitaka/components/nova
.. _Cinder: http://www.openstack.org/software/releases/mitaka/components/cinder
.. _Keystone: http://www.openstack.org/software/releases/mitaka/components/keystone
.. _Glance: http://www.openstack.org/software/releases/mitaka/components/glance
.. _Horizon: http://www.openstack.org/software/releases/mitaka/components/horizon
.. _Neutron: http://www.openstack.org/software/releases/mitaka/components/neutron

OpenStack is a large framework that consists of an increasingly
growing number of components. The following components are installed
in the UH-IaaS cloud. Each of the components have a general
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
  can be stored into an external service such as Glance.

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

Demo projects
-------------

.. _this web form: https://skjema.uio.no/iaas-project

You will be allocated a demo project the first time you logon . This
project is personal and for testing purposes.  There is a limited
quota for this demo project. If you need additional resources or a
project in which you wish to collaborate with other users, please
apply for a proper project using `this web form`_.

Demo projects use excess resources that are usually available under
normal operation, however, if there is a shortage of resources please
note that we may terminate some or all instances running in demo
projects without prior notice.

Quotas are set by region. Projects that haven't been given a quota in
their respective region will be automatically given a default quota.

=================== =========== =========== 
 Quota               Name        Default
=================== =========== ===========
 Instances           instances    2         
 vCPU                cores        2        
 Memory              ram          2048 MB   
 Number of volumes   volumes      1       
 Volume size         gigabytes    20 GB     
 Volume snapshots    snapshots    3          
=================== =========== ===========

**Instances**
  The total number of instances possible to create in a project.

**vCPU**
  The number of processors (vCPU) available to an instance.

**Memory**
  The amount of memory availble to an instance.

**Number of volumes**
  In UH-Iaas, block storage is called volume. The number indicates how many volumes are available in a project.

**Volume size**
  The total size of all volumes in a project.

**Volume snapshots**
  The total number of snapshots of all volumes in a project.


Proper projects
---------------

You can apply for a proper project (i.e. not demo) by using `this
web form`_. In this form, you need to give some information about
the project. Most importantly, we separate between personal and shared
projects:

**Personal**
  Personal projects are used by only one user. Only you will have
  access to your personal project.

**Shared**
  Shared projects can have multiple users. Users can be added or
  removed at any time, but access control is done by contacting
  UH-IaaS support. In order to add a user, the user must have logged
  in to UH-IaaS at least once, else the user isn't known in the
  system.
