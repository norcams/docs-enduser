Security Group Sanity Check
===========================

.. _CIDR: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
.. _CIDR (Wikipedia): https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
.. _CIDR Calculator IPv6: https://www.vultr.com/resources/subnet-calculator-ipv6/
.. _CIDR Calculator IPv4: https://www.vultr.com/resources/subnet-calculator/

.. contents::

Security groups are firewalls in OpenStack. They consist of one or
more firewall rules, called **security group rules**. Usually, a
security group rule is used to open one or more ports to one or more
IP addresses, giving access to servives on the instances on which the
security group is applied.

Creating security group rules can be easy or difficult, depending on
one's understanding of networking and firewalls. Regardless, it's easy
to make mistakes and open up more than intended. For this reason,
security group rules are checked.

Each security group rule is checked every day. This check is automatic
and looks for simple mistakes by the user:

* Wrong IP and subnet mask combination
* The rule opens too many ports to too many IP addresses

If the check finds a discrepancy, an email is sent to the project
admin, simply to make the admin aware of the issue. No further action
is taken. If the issue persists, a new email is sent after 30 days,
then every 30 days until the issue is fixed.


General Considerations
----------------------

The following general considerations governs the check:

* Only single rules are checked. We do not consider complete security
  groups, or the combination of security groups that comprise the
  firewall in front of an instance

* Only rules that are member of a security groups that are applied to
  actual instances, are checked. Unused security group rules are
  ignored

* The IP address ranges of UiO and UiB are whitelisted. As long as the
  IP address and subnet mask decribes a subset of these ranges, the
  rule is ignored

* Ports 22 (ssh), 80 (http) and 443 (https) are whitelisted. Any rule
  that opens to one of these three ports is ignored

* The ICMP protocol is whitelisted. Rules that open for ICMP are
  ignored

* Only ingress rules (incoming traffic) are checked. Egress rules
  (outgoing traffic) are ignored

* Only rules that use a CIDR_ address as target are checked. Rules
  that use a security group as target are ignored


Wrong Subnet Mask
-----------------

The system accepts what we consider to be a «wrong» subnet mask and IP
combination. For example, the system accepts ``129.240.114.36/0`` as a
valid CIDR_ address. However, this is identical to ``0.0.0.0/0`` as a
subnet mask of ``0`` negates the IP address in its entirety. This is an
extreme example, in which the user probably wanted to give access to a
single host but ended up giving access to the entire internet. The
correct CIDR_ address that describes a single host in this case would
be ``129.240.114.36/32``.

A less extreme example would be ``129.240.114.0/16``. The subnet mask
of ``16`` is too low number, and this CIDR_ address is effectively the
same as ``129.240.0.0/16``. Here the user probably meant
``129.240.114.0/24`` or similar.

These are IPv4 examples. The same applies to IPv6. For example, the
CIDR_ address ``2001:700:100:8070::36/0`` is valid, but the subnet mask
``0`` negates the entire IP address and this CIDR_ is then exactly the
same as ``::/0``, the entire internet.

If you get an alert about wrong subnet mask, the email will also
contain the minimum subnet mask that makes sense. Note that this is
the **minimum** subnet mask. It should be this number or higher.


Port Limits
-----------

The NREC team has created a set of port limits, which describes the
maximum number of ports one should open for a specific subnet mask:

* For subnet masks ``0`` through ``16`` (IPv4) or ``0`` through ``64``
  (IPv6), only a single port is considered safe

* For subnet mask ``32`` (IPv4) or ``128`` (IPv6), you may open all
  65536 ports

* For subnet masks between ``16`` and ``32`` (IPv4) or ``64`` and
  ``128`` (IPv6), the number of ports that is considered safe for a
  given subnet mask :math:`m` is calculated by the formula
  :math:`2^{m - 16}` (IPv4) or :math:`2^{\frac{m - 64}{4}}` (IPv6)

We recommend that you stay within these limits to ensure that your
instances are safe. Always try to open just enough and not more than
you need.


How to Fix?
-----------

.. _Deleting Rules: security-groups.html#deleting-rules
.. _Adding Rules: security-groups.html#adding-rules
.. _Understanding CIDR Notations: security-groups.html#understanding-cidr-notations

Chances are that you are visiting this documentation page because you
have received an email from us. The first thing you need to know is
that security group rules are immutable and can't be edited. Your only
option is to delete the problematic rule, and create a new rule (or
several rules) to replace it.

1. Follow the guide on how to delete a security group rule: `Deleting
   Rules`_. Make a note about the details of the rule you are
   deleting, in case you want to replace it. The email also contains
   these details.

2. Follow the guide on how to create security group rules: `Adding
   Rules`_. Bear in mind to use a CIDR_ with a correct subnet mask
   (see `Understanding CIDR Notations`_), and be as conservative as
   possible when opening ports to CIDR_ addresses. See the `Port
   Limits`_ section above for details.

When the problematic rule has been deleted you will no longer receive
alerts about that rule. You may receive alerts about the new rules
that replace it, if we find that those are problematic.
