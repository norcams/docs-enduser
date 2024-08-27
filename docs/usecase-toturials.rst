.. |date| date::

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
 
