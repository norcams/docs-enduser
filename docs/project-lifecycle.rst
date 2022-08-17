.. |date| date::

Project Lifecycle
=================

Last changed: 2022-08-17

.. contents::

.. IMPORTANT:: **This page is under construction. The lifecycle policy
	       is not yet live**

All NREC projects have a life span determined by the date of the
creation and the expiration date, sometimes referred to as "end
date". This document outlines what happens to a project

* **before** it reaches its expiration date
* **when** it reaches its expiration date
* **after** the expiration date

The figure below is a graphical representation of the life cycle of a
project. The project is created and enters normal operation. At the
end of its lifetime it enters quarantine status for 90 days and is
then deleted.
  
.. figure:: images/project-lifecycle.drawio.png
   :align: center
   :alt: Project Lifecycle

The main motivation for enforcing a limited life span for projects is
to make sure that projects are deleted when they are no longer in
use. This mitigates security issues that would otherwise arise as the
result of unmaintained instances (servers), and frees up resources for
other users.


Policy
------

Before a project reaches its expiration date, the administrator of the
project, as well as the contact if it exists, will be notified by
email. When a project reaches expiration date, it is put into
quarantine for 90 days and then deleted. When a project is deleted,
all of its resources (instances, volumes, snapshots etc.) and all data
contained within those resources are deleted forever. There are no
backups.

Detailed description of the policy:

#. **60 days before expiration date**: An email is sent to the project
   admin (and contact, if it exists) warning about pending quarantine

#. **30 days before expiration date**: An email is sent to the project
   admin (and contact, if it exists) warning about pending quarantine

#. **7 days before expiration date**: An email is sent to the project
   admin (and contact, if it exists) warning about pending quarantine

#. **At expiration date**: The project is put into quarantine. The
   following happens to a project that enters quarantine:

   - All instances are shut off
   - The project is disabled. Disabled projects can not be interacted
     with, and they are not visible in the dashboard
   - The project is tagged as being in quarantine
  
#. **30 days after entering quarantine**: An email is sent to the
   project admin (and contact, if it exists) warning about pending
   deletion

#. **60 days after entering quarantine**: An email is sent to the
   project admin (and contact, if it exists) warning about pending
   deletion

#. **90 days after entering quarantine**: The project is deleted

This process may be interrupted at any time. See `Expiration Date
Extension`_ below. If a project is enabled from quarantine, the
project's administrator and members are responsible for activating
instances that were shut off when the project entered quarantine.


Expiration Date Extension
-------------------------

A project's expiration date can be extended at any time. The maximum
allowed lifetime for a project is two years from today. Extending the
lifetime is an administrative task and must be performed by the NREC
team. To change the expiration date for a project, please contact NREC
support by sending an email to

* support@nrec.no

In normal circumstances, expiration date extension is merely a
formality and is granted without question. Do not hesitate to ask for
an extension if needed.
