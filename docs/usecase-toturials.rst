.. |date| date::

.. _Current GOLD images: nrec-gold-images.html#current-gold-images
.. _How do I set the root password for my Linux instance?: faq.html#how-do-i-set-the-root-password-for-my-linux-instance

Use case toturials
==================

Last changed: |date|

.. contents::

Changing network interface for a running instance
-------------------------------------------------

It is possible to change the network interface (i.e., from dualStack to IPv6)
without rebooting or rebuilding your VM instance. This is possible between all
available networks in the dashboard. Changing network interface will change the IP
addresses of the instance. This toturial demonstrates how to change the network
interface from dualStack to IPv6.

.. TIP::
   **Set root password!**

   It is a good idea to set the root password prior to doing any network changes.
   The instance can then be accessed using the "Console" view in the dashboard.

In the Dashboard:

1. In the drop-down menu of your running instance, select "Detach Interface" (Figure 1).

   .. figure:: images/uc-if-1.png
      :align: center
      :figwidth: image

      Figure 1: Drop-down menu of the running instance (in Compute -> Instances). The first three options are shown. We will use all three options in this toturial.
 
2. Select the network to detach under "Port". In Figure 2, a dualStack network configuration that is currently used by the running VM instance, is selected for detachment.

   .. figure:: images/uc-if-2.png
      :align: center
      :figwidth: image

      Figure 2: Selecting existing network to detach.
 
3. In the drop-down menu of your running instance, select "Attach Interface" (Figure 1).

4. Select the new (suggested) network to attach. In Figure 3, a new IPv6 network is selected.

   .. figure:: images/uc-if-3.png
      :align: center
      :figwidth: image

      Figure 3: Selecting new network to attach.
 
.. TIP::
   **Automatic removal of security groups**

   Note that all security groups that used the network that you detached were removed
   from the instance as a result of detaching the interface. Because of this, you need to
   re-add the affected security group(s). In the drop-down menu of the running instance (Figure 1), select "Edit Instance". In this toturial, a security group for SSH access
   is re-added as shown in Figure 4.

   .. figure:: images/uc-if-4.png
      :align: center
      :figwidth: image

      Figure 4: Adding security group for SSH access.

Linux VM user management
------------------------

Your Linux VM will come with a root user in addition to a cloud user as described in `Current GOLD images`_.

User management follows standard Linux procedures. Below are some useful commands:

.. list-table:: Table 1: Linux commands for basic user management.
   :widths: 50 25 25
   :header-rows: 1

   * - Command
     - Description
     - Use case
   * - ``openssl rand -base64 6``
     - Generate random 6-digit password
     - Interactive
   * - ``sudo adduser <username>``
     - Create a new user with a password
     - Interactive
   * - ``sudo adduser --disabled-password <username>``
     - Create a new user with disabled password
     - When creating users with key-based login only. The user cannot be authenticated using password
   * - ``sudo useradd -m -s /bin/bash <username>``
     - Create a new user without specifying its password
     - -"-, non-interactive
   * - ``sudo passwd <username>``
     - Set password for user
     - Interactive
   * - ``sudo gpasswd -a <username> <groupname>``
     - Add user <username> to the group <groupname>
     - Ex. adding user admin to group sudo
   * - ``sudo passwd -l <username>``
     - Disable (lock) the password for <username>
     - The user can no longer be authenticated using password. Login to the user with other authentication methods will still work
   * - ``google-authenticator``
     - Run 2FA setup for scanning QR code with OTP mobile app
     - When having set up SSH to use the Google Authenticator PAM

Example:

Creating the additional user student with disabled password. From root:

.. code-block:: console

   adduser --disabled-password student

This should also create the home directory ``/home/student``.

SSH keys

The public SSH key you selected in the in the wizard when creating the VM instance, was installed for the cloud and root user. However, by default, public key-based SSH login is only enabled for the cloud user. If you like to enable this for root (not recommended), you need to edit the correspondig settings in ``/etc/ssh/sshd_config``, followed by a restart of the ssh service.

Example:

The manual process of installing the public SSH key for student is the following (from root):

.. code-block:: console

   mkdir -p /home/student/.ssh
   # Substitute KEY with the public SSH key received from user student
   echo KEY >> /home/student/.ssh/authorized_keys

2FA/MFA

You may want to setup the VM to use a pluggable authentication module (PAM) with your public SSH key `and` mobile one-time-password (OTP) app. Google Authenticator provides such a setup. The installation may vary with Linux distribution. For Debian-based systems, the package to install is ``libpam-google-authenticator`` and configuration is performed in ``/etc/pam.d/sshd`` and ``/etc/ssh/sshd_config``.

Example: Assuming that Google Authenticator PAM is setup correctly with the SSH server in the VM. From root:

.. code-block:: console

   su - student
   google-authenticator

A good default is to say yes ('y') to all options. A QR code should be printed. The student needs to somehow scan this QR code using any mobile OTP app. Additionally, the file ``/home/student/.google_authenticator`` will be created together with the generated QR code. This file can be deleted if you wish to re-run the ``google-authenticator`` command to get a new QR code.

Sudo

Passwordless sudo right is granted to the cloud user. This means that you may want to use sudo to set the root password while logged in with the cloud user, as described in `How do I set the root password for my Linux instance?`_. The config file enabling passwordless sudo for the cloud user should be located in ``/etc/sudoers.d/``. If you want passwordless sudo right for additional users, you can edit this file accordingly.

Example: To grant sudo right to user student, add user student to the group sudo. Then, find and edit the file where the cloud user is granted sudo right. For Ubuntu, the file is ``/etc/sudoers.d/90-cloud-init-users``. From root:

.. code-block:: console

   gpasswd -a student sudo
   echo -e '# User rules for ubuntu\nstudent ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/90-cloud-init-users

If you followed the examples in this toturial, note that student can change to any user in the VM (using sudo su - <username>).

To prevent student from accessing other users, student and any other users in the VM should not have sudo rights, as well as a disabled password.

Any user logged into the VM may change to another user with password enabled (using su - <username>). This is a reason to create users with the --disabled-password option.

Shared account:

A shared user group1 may be created with password, and the password can be shared within the group. All members of the group should then be able to login to the VM using user group1 and shared password simultaneously. Shared accounts may also be accomplished by sharing the full (private+public) SSH key and possibly OTP app. However, this use case would go against introducing these increased security measures in the first place.

