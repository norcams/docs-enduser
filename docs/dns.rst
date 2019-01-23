.. |date| date::

Using the DNS service
=====================

Last changed: |date|

.. contents::

The UH-IaaS DNS service is an OpenStack component
named **Designate**. With this, you can create DNS zones (domain
names) and DNS records within your zones.

Accessing the DNS zones GUI pane
--------------------------------

In the menu to the left in the dasboard, click on **DNS** and
then **zones**:

.. image:: images/dns-menu-01.png
   :align: center
   :alt: Accessing DNS zones menu item



FIXME.

Doing the same with CLI
-----------------------

Creating the zone via `openstack zone create`:

.. code-block:: console

  $ openstack zone create --email foo@bar.com mytestzone.com.
  +----------------+--------------------------------------+
  | Field          | Value                                |
  +----------------+--------------------------------------+
  | action         | CREATE                               |
  | attributes     |                                      |
  | created_at     | 2019-01-22T14:32:57.000000           |
  | description    | None                                 |
  | email          | foo@bar.com                          |
  | id             | ffdba4fd-0e04-4edb-8756-e4944c148d0a |
  | masters        |                                      |
  | name           | mytestzone.com.                      |
  | pool_id        | 794ccc2c-d751-44fe-b57f-8894c9f5c842 |
  | project_id     | a56e80c7c777419585b13ebafe024330     |
  | serial         | 1548167577                           |
  | status         | PENDING                              |
  | transferred_at | None                                 |
  | ttl            | 3600                                 |
  | type           | PRIMARY                              |
  | updated_at     | None                                 |
  | version        | 1                                    |
  +----------------+--------------------------------------+

List your zones:

.. code-block:: console

  $ openstack zone list
  +--------------------------------------+-----------------+---------+------------+--------+--------+
  | id                                   | name            | type    |     serial | status | action |
  +--------------------------------------+-----------------+---------+------------+--------+--------+
  | ffdba4fd-0e04-4edb-8756-e4944c148d0a | mytestzone.com. | PRIMARY | 1548167577 | ACTIVE | NONE   |
  +--------------------------------------+-----------------+---------+------------+--------+--------+

Creating an **A** record (IPv4 pointer), i.e. a DNS entry for
``test01.mytestzone.com`` that points to the IPv4 address ``10.0.0.1``:

.. code-block:: console

  $ openstack recordset create mytestzone.com. test01 --type A --records 10.0.0.1
  +-------------+--------------------------------------+
  | Field       | Value                                |
  +-------------+--------------------------------------+
  | action      | CREATE                               |
  | created_at  | 2019-01-22T14:36:04.000000           |
  | description | None                                 |
  | id          | 6910a762-d1aa-4e48-b14e-d9c44ecb81a3 |
  | name        | test01.mytestzone.com.               |
  | project_id  | a56e80c7c777419585b13ebafe024330     |
  | records     | 10.0.0.1                             |
  | status      | PENDING                              |
  | ttl         | None                                 |
  | type        | A                                    |
  | updated_at  | None                                 |
  | version     | 1                                    |
  | zone_id     | ffdba4fd-0e04-4edb-8756-e4944c148d0a |
  | zone_name   | mytestzone.com.                      |
  +-------------+--------------------------------------+

Creating a **AAAA** record (IPv6 pointer), i.e. a DNS entry for
``test01.mytestzone.com`` that points to the IPv6 address
``fd32:100:200:300::12``:

.. code-block:: console

  $ openstack recordset create mytestzone.com. test01 --type AAAA --records fd32:100:200:300::12
  +-------------+--------------------------------------+
  | Field       | Value                                |
  +-------------+--------------------------------------+
  | action      | CREATE                               |
  | created_at  | 2019-01-22T14:37:38.000000           |
  | description | None                                 |
  | id          | aead6644-b5e7-4f67-be23-f3ce3423c0e7 |
  | name        | test01.mytestzone.com.               |
  | project_id  | a56e80c7c777419585b13ebafe024330     |
  | records     | fd32:100:200:300::12                 |
  | status      | PENDING                              |
  | ttl         | None                                 |
  | type        | AAAA                                 |
  | updated_at  | None                                 |
  | version     | 1                                    |
  | zone_id     | ffdba4fd-0e04-4edb-8756-e4944c148d0a |
  | zone_name   | mytestzone.com.                      |
  +-------------+--------------------------------------+

Creating a **CNAME** record, i.e. an alias for another DNS entry:

.. code-block:: console

  $ openstack recordset create mytestzone.com. www --type CNAME --records test01.mytestzone.com.
  +-------------+--------------------------------------+
  | Field       | Value                                |
  +-------------+--------------------------------------+
  | action      | CREATE                               |
  | created_at  | 2019-01-22T14:45:30.000000           |
  | description | None                                 |
  | id          | da6708fd-4023-48a0-adb6-5c3373605e37 |
  | name        | www.mytestzone.com.                  |
  | project_id  | a56e80c7c777419585b13ebafe024330     |
  | records     | test01.mytestzone.com.               |
  | status      | PENDING                              |
  | ttl         | None                                 |
  | type        | CNAME                                |
  | updated_at  | None                                 |
  | version     | 1                                    |
  | zone_id     | ffdba4fd-0e04-4edb-8756-e4944c148d0a |
  | zone_name   | mytestzone.com.                      |
  +-------------+--------------------------------------+

Listing your DNS records for ``mytestzone.com``:

.. code-block:: console

  $ openstack recordset list mytestzone.com.
  +--------------------------------------+------------------------+-------+-------------------------------------------------------------+--------+--------+
  | id                                   | name                   | type  | records                                                     | status | action |
  +--------------------------------------+------------------------+-------+-------------------------------------------------------------+--------+--------+
  | 2cddfc55-00d5-49fd-bd0d-ead0650efa19 | mytestzone.com.        | SOA   | ns2.uh-iaas.no. foo.bar.com. 1548168330 3519 600 86400 3600 | ACTIVE | NONE   |
  | bc9a8f9e-73ad-4604-a292-0612629a51af | mytestzone.com.        | NS    | ns1.uh-iaas.no.                                             | ACTIVE | NONE   |
  |                                      |                        |       | ns2.uh-iaas.no.                                             |        |        |
  | 6910a762-d1aa-4e48-b14e-d9c44ecb81a3 | test01.mytestzone.com. | A     | 10.0.0.1                                                    | ACTIVE | NONE   |
  | aead6644-b5e7-4f67-be23-f3ce3423c0e7 | test01.mytestzone.com. | AAAA  | fd32:100:200:300::12                                        | ACTIVE | NONE   |
  | da6708fd-4023-48a0-adb6-5c3373605e37 | www.mytestzone.com.    | CNAME | test01.mytestzone.com.                                      | ACTIVE | NONE   |
  +--------------------------------------+------------------------+-------+-------------------------------------------------------------+--------+--------+

Testing your records:

.. code-block:: console

  $ host test01.mytestzone.com ns1.uh-iaas.no
  Using domain server:
  Name: ns1.uh-iaas.no
  Address: 2001:700:2:82ff::251#53
  Aliases: 
  
  test01.mytestzone.com has address 10.0.0.1
  test01.mytestzone.com has IPv6 address fd32:100:200:300::12
  
  $ host www.mytestzone.com ns2.uh-iaas.no
  Using domain server:
  Name: ns2.uh-iaas.no
  Address: 2001:700:2:83ff::251#53
  Aliases: 
  
  www.mytestzone.com is an alias for test01.mytestzone.com.
  test01.mytestzone.com has address 10.0.0.1
  test01.mytestzone.com has IPv6 address fd32:100:200:300::12

You can test against either **ns1.uh-iaas.no** or **ns2.uh-iaas.no**,
it doesn't matter. Both are authoritative name servers in the UH-IaaS
infrastructure, and does not resolve other domains than they serve
themselves.
