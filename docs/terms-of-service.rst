.. |date| date::

NREC Terms of Service
========================

Last changed: |date|

.. contents::

.. IMPORTANT:: **About this document**
   You should know what you're getting when you sign up for NREC,
   and what we expect from you in return. We've tried to keep the
   legalese to a minimum.

Signing up
----------

.. _Dataporten: https://www.uninett.no/en/
.. _here: https://access.nrec.no/

* In order to use the NREC infrastructure service, you first need to
  provision yourself here_.

* You must have a valid user account at an educational institution
  in Norway that has signed up for using NREC.

* You must provide your username, a valid email address, and any
  other information requested in order to complete the signup
  process.

* After you successfully signing up, you will get your API password.
  Make sure to note the password.

* Please carefully guard the security of your account and monitor use
  of your API password. You are responsible for all use of the services
  under your account, whether or not authorized, including any use of
  your API password.

* When you first log in, you are granted with a demo project. This
  project is personal and only for testing purposes.

Our services
------------

.. _Service Level Agreement: sla.html

* We will make the NREC services available to you in accordance
  with our agreement with your participating educational organization. Subject to these Terms,
  we grant you a non-exclusive, revocable license and right to:

  * Create and manage virtual machines within your quota limit.
  * Create and manage firewalls and SSH keys for use with your
    virtual machines.
  * Create and manage storage volumes for use with your virtual
    machines.

* You may only use the services for non-commercial purposes, for
  research purposes and educational purposes without charge.

* If you want to make use of the services outside this description,
  such as for commercial purposes, please contact us.

* If you need more resources (number of virtual machines, storage
  etc.) than your quota allows, please contact us.

* If you want to use NREC for critical services, or services that
  require high availability, please contact us.

* Please make sure to free up resources that you no longer use or
  need, such as terminating obsolete virtual machines.

Security
--------

* We will strive to maintain a set of "Golden Images" for popular
  Linux distributions that are updated on a monthly basis. These
  images will be easily recognizable, as they contain the word "GOLD"
  to distinguish them from images uploaded by users.

* Once you create a virtual machine from an image, the virtual machine
  becomes your responsibility. At a minimum, you should make sure that:

  * The operating system running on your virtual machine is updated
    regularly with security patches
  * The virtual machines are rebooted regularly for new patches to
    take effect

* Please adjust your firewalls (security groups) carefully, and allowing
  only necessary traffic to and from your virtual machines.

Availability
------------

* We do not guarantee a specific availability percentage at this
  time. We will try to keep things up and running, but this is done
  on a best effort basis.

* There will be regular, scheduled maintenance downtime every 4
  weeks. Downtime may require that running virtual machines are
  rebooted.

* For dedicated hardware, there will be scheduled maintenance on the
  second Tuesday of every month. Downtime will require that running
  virtual machines are rebooted.

* Whenever scheduled downtime affects running virtual machines, the
  owner of the virtual machines will be notified at least 5 days in
  advance.

* A period of unavailability is excluded from the service level
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
    government or other third parties; or other problems beyond our
    services.

* We reserve the right to terminate instances in your demo project
  without notice, if a situation should arise in which we need the
  compute resources elsewhere.

Content
-------

* Your content is your content. You retain ownership of all content
  that you place in NREC. Note that we may delete content in your
  demo project without notice.

* Your associated educational institution may exercise ownership of
  content according to Norwegian law.

* There are no backups. Deleted data is gone forever. Important data
  should be backed up outside of NREC.

* Content that needs to be persistent across reinstalls should be
  placed on volumes. The OS disks are ephemeral.

Privacy Policy
--------------

.. _email: mailto:support.uhiaas.no

* Email

  Your NREC project is closely related to your email account. We collect your email address via Dataporten_ as we need this information for authentication and notification purposes. We keep your email in our database as long as you are an active user of our services.
  If you change your email, you are responsible for notifying us so that we can update it, otherwise, you may risk losing your project and data.

* Instances (virtual machines)

  We do not monitor the content of instances, but may collect metrics (uptime, patch level and kernel version) for security reasons. You should make sure that your activities are in accordance with your local IT policy. You are responsible for all data you store on your own instances.

* Termination

  When you are no longer registered as an active student or no longer working at any educational institutions, your project will be terminated and deleted from our system after 90 days without prior notice.

* Withdrawal

  If you for any reasons want to stop using our services, you should notify us by sending an email_. We will then delete your project and all your data from our system. You are welcome to rejoin the NREC cloud whenever you want.

* Cookies

  The cookies are only used for logging in and NREC related tasks. No data from these will ever be shared with any third parties.
