.. |date| date::

Using Remote Desktop
====================

Last changed: |date|

.. contents::

.. _Remote Desktop Protocol: https://en.wikipedia.org/wiki/Remote_Desktop_Protocol
   
You may want to access virtual Windows servers in NREC via Windows
Remote Desktop (RDP). More info about `Remote Desktop Protocol`_.

There are two ways to reach the Windows instance using RDP:

* **Directly**: You establish an direct connection between your client
  computer and the NREC Windows server

* **Via an RDP Gateway**: You utilize an RDP Gateway as a proxy
  between your client and the NREC Windows server

Using an RDP gateway is will be necessary if connecting from outside
the Norwegian university network, once RDP is blocked as planned.


Allowing Access
---------------

.. _Working with Security Groups: security-groups.html

Refer to `Working with Security Groups`_ for an in-depth explanation
about security groups and how to create them. In order to allow Remote
Desktop, choose "RDP" as the Rule and apply a proper CIDR address:

.. figure:: images/rdp-security-group-01.png
   :align: center
   :alt: Allow the RDP protocol with security group

Here, we allow RDP only from ``2001:700:100:8040::5``, which is the
IPv6 address of rds-portal.uio.no.


Direct Connection
-----------------

.. NOTE:: **Only from network of Norwegian universities and colleges**
   Incoming traffic to port 3389 (RDP) is blocked (pending) if the origin is
   outside of networks belonging to Norwegian universities and
   colleges. Direct RDP connection is limited to these networks.

Windows
~~~~~~~
   
From your Windows client, open the **Remote Desktop Connection** app
and type in the IP address or hostname of your NREC Windows instance:

.. figure:: images/rdp-windows-01.png
   :align: center
   :alt: Windows Remote Desktop Connection (1)

Click on **Show Options** and type the username (usually "Admin"):

.. figure:: images/rdp-windows-02.png
   :align: center
   :alt: Windows Remote Desktop Connection (2)

Then click **Connect**. You will then be asked to provide the
password:

.. figure:: images/rdp-windows-03.png
   :align: center
   :alt: Windows Remote Desktop Connection (3)

Usually, you will then get a complaint about the certificate being
unverified. This is normal for NREC Windows instances and can be
ignored:

.. figure:: images/rdp-windows-04.png
   :align: center
   :alt: Windows Remote Desktop Connection (4)

Click **Yes** and you will then connect to the instance via remote
desktop.


Linux
~~~~~

In order to connect from Linux, you need to use xfreerdp or similar
software. For xfreerdp, we will connect to the same host as above with
the following command:

.. code-block:: console

  xfreerdp /cert:ignore /size:1280x1024 /kbd:Norwegian /u:Admin /v:[2001:700:2:8200::25c4]

The following options are used:

* **/cert:ignore**: We ask that it ignores the unverifiable
  certificate
* **/size:1280x1024**: The size of the window. Specify whatever size
  you want, or use **/f** instead for fullscreen
* **/kbd:Norwegian**: Specifies Norwegian keyboard layout
* **/u:Admin**: The username, usually "Admin"
* **/v:[2001:700:2:8200::25c4]**: The IP address of the Windows
  instance. For IPv6 as shown here, the address must be enclosed in
  brackets


Via RDP Gateway (UiO)
---------------------

*Coming soon*

