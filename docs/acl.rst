.. |date| date::

ACL for Incoming Traffic
========================

Last changed: |date|

.. contents::

There is a firewall that blocks incoming traffic to the NREC instances
and infrastructure. This is done to protect our users and their
services running on NREC.

Some ports are completely blocked, meaning that traffic to those ports
are not allowed from anywhere. For other ports, traffic from IP
addresses belonging to Norwegian universities and colleges are
allowed, and blocked from anywhere else.


Completely Blocked Ports
------------------------

The following ports are completely blocked:

+--------+--------+------------+--------------------------------------------+
|Port    |Protocol|Service     |Comment                                     |
+========+========+============+============================================+
|``23``  |All     |telnet      |Telnet is an unencrypted remote login       |
|        |        |            |service that should never be used. Use an   |
|        |        |            |encrypted service such as SSH instead       |
+--------+--------+------------+--------------------------------------------+
|``111`` |All     |portmapper  |The portmapper protocol is mostly used for  |
|        |        |            |NFS versions 2 and 3. It is vulnerable to   |
|        |        |            |DDoS attacks and should not be exposed to   |
|        |        |            |the internet                                |
+--------+--------+------------+--------------------------------------------+
|``139`` |All     |netbios-ssn |This port is used for SMB/CIFS              |
|        |        |            |services. Exposing SMB from NREC to the     |
|        |        |            |outside presents a wealth of security       |
|        |        |            |concerns                                    |
+--------+--------+------------+--------------------------------------------+
|``445`` |All     |microsoft-ds|This port is used for SMB/CIFS              |
|        |        |            |services. Exposing SMB from NREC to the     |
|        |        |            |outside presents a wealth of security       |
|        |        |            |concerns                                    |
+--------+--------+------------+--------------------------------------------+
|``2049``|All     |nfs         |Exposing NFS from NREC to the outside       |
|        |        |            |presents a lot of security concerns         |
|        |        |            |                                            |
|        |        |            |                                            |
+--------+--------+------------+--------------------------------------------+


Allowed only from Norwegian Universities and Colleges
-----------------------------------------------------

.. NOTE::
   This will be in effect from June 30, 2022.

The following ports are blocked, except from Norwegian universities
and colleges.

+--------+--------+--------------+--------------------------------------------+
|Port    |Protocol|Service       |Comment                                     |
+========+========+==============+============================================+
|``53``  |All     |Domain Name   |There are very few reasons why one would    |
|        |        |Service (DNS) |want to run DNS servers in NREC. An         |
|        |        |              |incorrectly configured DNS service could    |
|        |        |              |disrupt other services running on NREC      |
+--------+--------+--------------+--------------------------------------------+
|``123`` |All     |Network Time  |There are very few reasons why one would    |
|        |        |Protocol (NTP)|want to run NTP servers in NREC. An         |
|        |        |              |incorrectly configured NTP service could    |
|        |        |              |disrupt other services running on NREC      |
+--------+--------+--------------+--------------------------------------------+
|``1186``|All     |MySQL         |Database ports should never be open on the  |
|        |        |Cluster       |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``1433``|All     |Microsoft     |Database ports should never be open on the  |
|        |        |SQL Server    |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``1434``|All     |Microsoft     |Database ports should never be open on the  |
|        |        |SQL Monitor   |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``3128``|All     |Squid Web     |An exposed Squid service is a security      |
|        |        |Proxy         |concern and should not exist in NREC        |
+--------+--------+--------------+--------------------------------------------+
|``3306``|All     |MySQL         |Database ports should never be open on the  |
|        |        |              |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``5432``|All     |PostgreSQL    |Database ports should never be open on the  |
|        |        |              |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``5900``|All     |VNC           |Port used for VNC, which is easy to set up  |
|        |        |              |wrong and should noe be exposed on the      |
|        |        |              |internet                                    |
+--------+--------+--------------+--------------------------------------------+
|``8080``|All     |"Configuration|Port used by various web services           |
|        |        |Port"         |(e.g. Tomcat) for configuration and admin   |
|        |        |              |access. Should not be open to the whole     |
|        |        |              |internet                                    |
+--------+--------+--------------+--------------------------------------------+

The following ports will be added to the list above in August 2022:

+--------+--------+--------------+--------------------------------------------+
|Port    |Protocol|Service       |Comment                                     |
+========+========+==============+============================================+
|``25``  |All     |SMTP          |Port used by mail servers. If not managed   |
|        |        |              |with great care, mail servers are easily    |
|        |        |              |exploited                                   |
+--------+--------+--------------+--------------------------------------------+
|``3389``|All     |RDP           |Port used to grant graphical login access to|
|        |        |              |Windows servers. Easily exploitable if the  |
|        |        |              |server is not patched aggressively          |
+--------+--------+--------------+--------------------------------------------+
