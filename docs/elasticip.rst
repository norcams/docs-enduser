The NREC Elastic IP Service
===========================

Last changed: 2023-30-10

.. contents::

.. _BGP: https://en.m.wikipedia.org/wiki/Border_Gateway_Protocol
.. _ECMP: https://en.wikipedia.org/wiki/Equal-cost_multi-path_routing
.. _4 Byte Private AS Number: https://en.wikipedia.org/wiki/Autonomous_system_(Internet)
.. _MD5 password for BGP peering: https://en.wikipedia.org/wiki/MD5
.. _IPv4 prefix(es) you may announce: https://en.wikipedia.org/wiki/Internet_Protocol_version_4
.. _IPv6 prefix(es) you may announce: https://www.mediawiki.org/wiki/Help:Range_blocks/IPv6
.. _BFD: https://wiki.ietf.org/group/bfd
.. _Anycast: https://en.wikipedia.org/wiki/Anycast
.. _Bird: https://bird.network.cz/
.. _Free Range Routing: https://frrouting.org/
.. _GoBGP: https://osrg.github.io/gobgp/
.. _ExaBGP: https://github.com/Exa-Networks/exabgp
.. _AnyCast Healthcecker: https://github.com/unixsurfer/anycast_healthchecker
.. _MetalLB in FRR mode: https://metallb.universe.tf/concepts/bgp/#frr-mode

Introduction
------------

NREC Elastic IP allows projects to announce anycast IP addresses within
a site and enables potential for load balancing and/or failover for
your services. You may advertise extra addresses for project instances
via Border Gateway Protocol (BGP_), either IPv4 and/or IPv6 addresses.
If the same address is advertised from multiple instances, Equal Cost
Multipath (ECMP_) routes will be created in the NREC infrastructure.

Example usecases for this feature include MetalLB for container clusters
and failover-handling haproxy servers.

.. NOTE::
  This feature is not intended for inexperiended users, and some understanding
  of BGP and networking is required. Therefore, it is a feature available
  on request only, and the NREC team reserves every right to refuse
  access to the feature without justification or explaination.

How it works
------------

Each project consuming the Elastic IP feature will get access to an
OpenStack network called "Elastic IP". The OpenStack network itself provides
IP addresses similar to the "IPv6" network, the instances consuming the
network receive a private IPv4 address with NAT connectivity and a public
IPv6 address. The project will also be provided with:

==================================== ========= ================================
Parameter                            Mandatory Example   
==================================== ========= ================================
A `4 Byte Private AS Number`_        Yes       4164939142
An AS Number for the NREC peers      Yes       65535
`MD5 password for BGP peering`_      Yes       b1ecd7f662e6ff6ce03ab33626f92cfe
IPv4 endpoints for BGP peering       Yes       10.255.255.1, 10.255.255.2
`IPv4 prefix(es) you may announce`_  No        192.168.0.16/31
`IPv6 prefix(es) you may announce`_  No        fda4:5ff2:8477:1755::/127
Whether BFD_ will be enabled         No        Yes or No
==================================== ========= ================================

After launching one or more instances attached to "Elastic IP" OpenStack network,
you are ready to advertise anycast addresses.

Example configuration
---------------------

In this example we will launch an instance, install a BGP_ speaker and verify
IPv4 and IPv6 connectivity. Launching the instance is nothing different from what
you normally would do, the only difference being the OpenStack network the instance
attaches to. In our example we will be using the popular BGP speaker Bird_, other
widely used BGP speakers include `Free Range Routing`_, GoBGP_ and ExaBGP_.

.. IMPORTANT::
  The security groups you configure for your instance will be applied to the
  Openstack network for the instance, as well as to the IP addresses announced
  by the instance.

Installing Bird is trivial as it is available in most linux distributions
(Enterprise Linux may require the EPEL repository). For example, in recent Ubuntu
releases it can be installed with

.. code-block:: console

  # sudo apt-get install -y bird2

A working bird configuration (/etc/bird.conf) could look like this:

.. code-block:: console

  router id 10.0.240.156; # This instance's IPv4 address
  
  filter export_bgp_v4 {
      if net ~ 192.168.0.16/31 then accept; # Max prefix length /32
      else {
          reject;
      }
  }
  
  filter export_bgp_v6 {
      if net ~ fda4:5ff2:8477:1755::/127 then accept;
      else {
          reject;
      }
  }
  
  protocol device {
    scan time 5;
  }
  
  protocol direct {
          disabled;
  }
  
  protocol kernel {
          learn;
          scan time 2;
          ipv4 {
                import all;
                export all;
          };
  }
  
  protocol kernel {
          learn;
          scan time 2;
          ipv6 {
                import all;
                export all;
          };
  }
  
  protocol bfd {
    accept ipv4 multihop;
  }
  
  protocol bgp nrec_peer1  {
    neighbor 10.255.255.1 port 179 as 65535;
    local 10.0.240.156 as 4200000000;
    multihop;
    password "b1ecd7f662e6ff6ce03ab33626f92cfe";
    bfd graceful;
    ipv4 {
          import none;
          export filter export_bgp_v4;
          gateway recursive;
        };
    ipv6 {
          import none;
          export filter export_bgp_v6;
          gateway recursive;
          };
    source address 10.0.240.156;
  }
  
  protocol bgp nrec_peer2  {
   neighbor 10.255.255.2 port 179 as 65535;
    local 10.0.240.156 as 4200000000;
    multihop;
    password "b1ecd7f662e6ff6ce03ab33626f92cfe";
    bfd graceful;
    ipv4 {
          import none;
          export filter export_bgp_v4;
          gateway recursive; 
          };
    ipv6 {
          import none;
          export filter export_bgp_v6;
          gateway recursive;
          };
    source address 10.0.240.156;
  }

The important features that need to be supported by your preferred BGP speaker
are the ability to do eBGP multihop, 4 byte AS numbers and (optionally) BFD
multihop. The terms "nrec_peer1" and "nrec_peer2" are bird specific arbitrary labels.
After starting the bird daemon, you can check if the desired connections are
working:

.. code-block:: console

  # birdcl show protocol
  BIRD 2.14 ready.
  Name       Proto      Table      State  Since         Info
  device1    Device     ---        up     2023-10-24    
  direct1    Direct     ---        down   2023-10-24    
  kernel1    Kernel     master4    up     2023-10-24    
  kernel2    Kernel     master6    up     2023-10-24    
  bfd1       BFD        ---        up     2023-10-24    
  nrec_peer1 BGP        ---        up     2023-10-26    Established   
  nrec_peer2 BGP        ---        up     2023-10-26    Established

.. WARNING::
  If running BFD, you *must* create a security group that opens the necessary
  UDP ports for BFD to work, reachable from the NREC network infrastructure
  loopback addresses (the addresses you are peering against). Open UDP port
  range 4784-4785 for remote IPs (in this example) 10.255.255.0/30.

You should also check more details pr protocol, for example

.. code-block:: console

  # birdcl show bfd sessions
  BIRD 2.14 ready.
  bfd1:
  IP address                Interface  State      Since         Interval  Timeout
  10.255.255.1              ---        Up         2023-10-26      0.300    0.900
  10.255.255.2              ---        Up         2023-10-26      0.300    0.900

At this point we can start advertising prefixes. Given the above configuration,
we want to advertise an IPv4 address within the 192.168.0.16/31 range. First,
we have to actually assign the IP address to an interface on the instance. That
interface can be of the dummy interface type, or you can assign the IP address
directly to the loopback interface, which may be the easiest method.

.. code-block:: console

  # ip addr add 192.168.0.16/32 dev lo
  # ip -6 addr add fda4:5ff2:8477:1755::0/128 dev lo

The advertisements happen as soon as there are routes to the IP addresses.

.. code-block:: console

  # ip route add 192.168.0.16/32 dev lo
  # ip -6 route add fda4:5ff2:8477:1755::0/128 dev lo

Likevise, the advertisements will stop as soon as you delete the routes.
In our example, we can check which prefixes we are announcing with

.. code-block:: console

  # birdcl show route export nrec_peer1 # (or nrec_peer2)
  BIRD 2.14 ready.
  Table master4:
  192.168.0.16/32   unicast [kernel1 2023-10-24] * (10)
    dev lo

  Table master6:
  fda4:5ff2:8477:1755::0/128 unicast [kernel2 2023-10-24] * (10)
    dev lo

The addresses should now be reachable from other instances, and from
The Internet as well, if opened in your security groups.

.. NOTE::
  In this example, we have been using private addressing for both IPv4
  and IPv6. Normally, these addresses would of course have been world wide
  addressable, public IP addresses.

Next steps
----------

More instances advertising the same IP addresses may be created with
identical configuration for the BGP speaker software - the only difference
being the instance's own address. Depending on your usecase, a service health
checker can be useful. For example, `AnyCast Healthcecker`_ configures the Bird
daemon directly. If you are using MetalLB, please note that by default MetalLB
will try peering all your nodes with the infrastructure. This may not be
optimal, so consider deploying only a few nodes to run that service. Also,
you *must* run `MetalLB in FRR mode`_ - running in default BGP mode is not
supported by the NREC Elastic IP feature.

Additional example configurations
---------------------------------

Please let us know if you have specific uses cases for other BGP speakers
and need help to get it working.
