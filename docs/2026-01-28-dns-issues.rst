.. |date| replace::   2026-01-28
.. |author| replace:: Trond H. Amundsen

[|date|] Deviation Report: DNS Issues
=====================================

Date: |date|
Author: |author|

.. contents::


Summary
-------

Some DNS domains that was delegated to the NREC name servers and
administered with the NREC DNS Service, failed to resolve for
approximately one hour starting at 11:45.


Description
-----------

NREC changed its name from "UH-IaaS" to "NREC" a few years ago, and a
new DNS domain `nrec.no` was also aquired to replace the obsolete
`uh-iaas.no` domain. The domain `uh-iaas.no` had been working in
parallel since the name change, and we decided that it was time to
delete the old domain.

We failed to recognize that some delegated domains still used the old
addresses for the authoritative name servers (`ns1.uh-iaas.no` and
`ns2.uh-iaas.no`). The unintended and unforeseen consequence was that
these domains failed to resolve when the `uh-iaas.no` domain was
removed.

Timeline:

* **11:45**: The `uh-iaas.no` domain was removed

* **12:09**: The first issues with DNS in NREC is reported. The NREC
  team quickly identified the problem and decided on a solution

* **12:45**: The `uh-iaas.no` domain, including `A` records for
  `ns1.uh-iaas.no` and `ns2.uh-iaas.no` was restored

The perceived timeline for customers may differ from the one above,
due to local cache on their respective resolvers.


Consequences
------------

DNS zones that was delegated a long time ago were using the old
nameserver names. These zones failed to resolve for approximately one
hour.


How could this be avoided?
--------------------------

We could and should have recognized that zone delegation would be a
potential issue.


Could we have handled the issue better?
---------------------------------------

Not really. We monitored the situation for potential issues after
deleting the `uh-iaas.no` domain, and were quick to respond.


Mitigation Measures
-------------------

We will follow this procedure in order to avoid this problem in the
future:

#. Identify which delegated zones use the old DNS server names

#. Contact the owners of the zones in question and ask them to change
   the delegation to using the new (correct) DNS server names

#. When all delegated zones have been verified as using the correct
   DNS server names, delete the `uh-iaas.no` zone
