.. |date| date::

NREC Terms of Service
========================

Last changed: 2022-08-17

.. contents::

.. IMPORTANT:: **About this document**
   You should know what you're getting when you sign up for NREC,
   and what we expect from you in return. We've tried to keep the
   legalese to a minimum.

Signing up
----------

.. _Dataporten: https://www.uninett.no/en/
.. _access.nrec.no: https://access.nrec.no/

* In order to use the NREC infrastructure service, you must have
  a valid user account at an educational institution in Norway that
  has signed up for using NREC.

* To get access to NREC, you need to provision yourself access.nrec.no_
  for the first time.

* You must provide your username, a valid email address, and any
  other information requested in order to complete the signup
  process.

* After you successfully signing up, you will get your API password.
  Make sure to note the password.

* Please carefully guard the security of your account and monitor use
  of your API password.

* You are responsible for all use of the services
  under your account, whether or not authorized, including any use of
  your API password.

* When you first log in, you are granted with a demo project. This
  project is personal and only ment for testing purposes.

Our services
------------

.. _Service Level Agreement: sla.html

* We will make the NREC services available to you in accordance
  with our agreement with your participating educational organization.
  Subject to these Terms, we grant you a non-exclusive, revocable
  license and right to:

  * Create and manage virtual machines within your quota limit.
  * Create and manage firewalls and SSH keys for use with your
    virtual machines.
  * Create and manage storage volumes for use with your virtual
    machines.

* You may only use the services for non-commercial purposes, for
  research purposes and educational purposes without charge.

* If you want to make use of the services for commercial purposes,
  please contact us.

* If you need to extend your resources (number of virtual machines,
  storage, etc.) than your quota allows, please contact us.

* If you want to use NREC for critical services, or services that
  require high availability, please contact us.

* Make sure to free up resources that you no longer use or need,
  such as terminating obsolete virtual machines.

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
  after 90 days. When an instance terminates, the data on any instance
  store volumes and images associated with that instance will also be
  deleted. We will notify you by email in advance.

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

Terms and Conditions
--------------------

.. _email: support@nrec.no
.. _Project Lifecycle: project-lifecycle.html

* Project Termination:

  Excluding DEMO projects, all projects have an expiration date (also
  referred to as "enddate"). When a projects reaches its expiration
  date, it will enter quarantine status, in which the project is
  inaccessible. After 90 days in quarantine, the project is
  deleted. Contact us by email_ in order to extend the lifetime of a
  project beyond its current expiration date. Further details are
  available here:

  `Project Lifecycle`_

* Instance Termination:

  Instances created in DEMO projects have a 90-day lifespan. Instances
  created in other projects follow the lifecycle of the project as
  described here:

  `Project Lifecycle`_

  When an instance terminates, any data on the instance disk are
  deleted.

* Protect Data:

  To help protect against data loss, make sure you have an offsite
  backup for your data regularly. NREC doesn't offer onsite backup.

* Security Alert:

  When abuse is reported, we will immediately shut down and lock your
  instance, and alert you so you can take the necessary remediation
  action. We will work with you to detect and address suspicious and
  malicious activities from your instance.  If you do not take action
  to remediate the abuse event, we may suspend or terminate the
  instance.

  If a vulnerability is detected in your services running on NREC, we
  will perform a risk assessment. In cases where the risk is
  considered to be high, we will immediately shut down and lock the
  instance.

* Policy Violation:

  If you violate the NREC's policy, we may suspend or terminate your
  use of the services. Policy violations such as illegal, harmful, or
  offensive use or content, security violations, and network abuse. If
  you become aware of any violation of this policy, please send an
  email_.

Privacy Policy
--------------

.. _email: mailto:support.uhiaas.no

* Email:

  Your NREC project is closely related to your email account. We
  collect your email address via Dataporten_ as we need this
  information for authentication and notification purposes. We keep
  your email in our database as long as you are an active user of our
  services. If you change your email, you are responsible for
  notifying us so that we can update it, otherwise, you may risk
  losing your project and data.

* Instances (virtual machines):

  We do not monitor the content of instances, but may collect metrics
  (uptime, patch level and kernel version) for security reasons. You
  should make sure that your activities are in accordance with your
  local IT policy. You are responsible for all data you store on your
  own instances.

* Termination:

  When you are no longer registered as an active student or no longer
  working at any educational institutions, your project will be
  terminated and deleted from our system after 90 days without prior
  notice.

* Withdrawal:

  If you for any reasons want to stop using our services, you should
  notify us by sending an email_. We will then delete your project and
  all your data from our system. You are welcome to rejoin the NREC
  cloud whenever you want.

* Cookies:

  The cookies are only used for logging in and NREC related tasks. No
  data from these will ever be shared with any third parties.
