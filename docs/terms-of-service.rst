.. |date| date::

UH-IaaS Terms of Service
========================

Last changed: |date|

.. contents::

.. IMPORTANT:: **About this document**
   You should know what you're getting when you sign up for UH-IaaS,
   and what we expect from you in return. We've tried to keep the
   legalese to a minimum.

Signing up
----------

#. In order to use the UH-IaaS infrastructure service, you must sign
   up with the Dataporten authentication and authorization service.

#. You must have a valid user account at any educational institution
   in Norway that has signed up for using UH-IaaS.

#. You must provide your username, a valid email address, and any
   other information requested in order to complete the signup
   process.

#. When signing up with Dataporten, make sure to note your API key. It
   cannot be retreived afterwards.

#. Please carefully guard the security of your account and monitor use
   of your API keys. You are responsible for all use of the Services
   under your account, whether or not authorized, including any use of
   your API keys.

Our services
------------

.. _Service Level Agreement: sla.html

#. We will make the UH-IaaS services available to you in accordance
   with our agreement with your participating educational
   organization. Subject to these Terms, we grant you a non-exclusive,
   revocable license and right to:

   * Create and manage virtual machines within your quota limit.
   * Create and manage firewalls and SSH keys for use with your
     virtual machines.
   * Create and manage storage volumes for use with your virtual
     machines.

#. You may only use the Services for non-commercial purposes, for
   research purposes and educational purposes without charge.   

#. If you want to make use of the Services outside this description,
   such as commercial purposes, please contact us.

#. If you need more resources (number of virtual machines, storage
   etc.) than your quota allows, please contact us.

#. If you want to use UH-IaaS for critical services, or services that
   require high availability, please contact us.

#. Please make sure to free resources that you no longer use or need,
   such as terminating obsolete virtual machines.

Security
--------

#. We will strive to maintain a set of "Golden Images" for popular
   Linux distributions, that are updated at a monthly basis. These
   images will be easily recognizable as they contain the word "GOLD"
   to distinguish them from images uploaded by users.

#. Once you create a virtual machine from an image, the virtual
   machine becomes your responsibility. At a minimum, you should make
   sure that:

   * The operating system running on your virtual machine are updated
     regularly with security patches
   * The virtual machines are rebooted regularly for new patches to
     take effect

#. Please adjust your firewalls (security groups) carefully, allowing
   only necessary traffic to and from your virtual machines.

Availability
------------

#. We do not guarantee a specific availability percentage at this
   time. We will try to keep things up and running, but this is done
   on a best effort basis.

#. There will be regular, scheduled maintenance downtime every 4
   weeks. Downtime may require that running virtual machines are
   rebooted.

#. Whenever scheduled downtime affects running virtual machines, the
   owner of the virtual machines will be notified at least 5 days in
   advance.

#. A period of unavailability is excluded from the service level
   guarantee, if:

   * the unavailability is due to scheduled maintenance, provided we
     notify you at least 5 days in advance;
   * you are in breach of our terms of service, or your services
     agreement with us, as applicable (including your payment
     obligations to us), or the unavailability is otherwise due to
     your actions;
   * the unavailability is caused by factors outside of our reasonable
     control, including a force majeure event; internet access
     problems; blocking, filtering, or censorship of our services by a
     government or other third party; or other problems beyond our
     services.

Content
-------

#. Your content is your content. You retain ownership of all content
   that you place in your personal project.

#. Your associated educational institution may exercise ownership of
   content according to Norwegian law.

#. There are no backups. Deleted data is gone forever. Important data
   should be backed up outside of UH-IaaS.

#. Content that needs to be persistent across reinstalls should be
   placed on volumes. The OS disks are ephemeral.
