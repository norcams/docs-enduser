Affinity and Anti-Affinity with Server Groups
=============================================

Last changed: 2024-11-25

.. contents::

A **Server Group** is a collection of instances, and can be used as a
mechanism for indicating the location of instances on hypervisors in
relation to other instances. They allow you to indicate whether
instances should run on the same hypervisor (Affinity) or different
hypervisors (Anti-Affinity). Affinity is advantageous if you wish to
minimise network latency, while anti-affinity can improve
fault-tolerance and load distribution.

Policies and rules
------------------

Server groups can be configured with a policy and rules. There are
currently four policies supported:

**affinity** - AVOID THIS

  Restricts instances belonging to the server group to the same
  hypervisor.

  .. WARNING:: **NREC does not allow the affinity policy**
    The affinity policy interferes with the migration of instances
    during hypervisor maintenance. While NREC technically allows this
    policy, the NREC team will delete any server groups with affinity
    policy whenever they are encountered.

**anti-affinity**

  Restricts instances belonging to the server group to separate
  hypervisors.

**soft-affinity**

  Attempts to restrict instances belonging to the server group to the
  same hypervisor. Where it is not possible to schedule all instances
  on one hypervisor, they will be scheduled together on as few
  hypervisors as possible.

**soft-anti-affinity**

  Attempts to restrict instances belonging to the server group to
  separate hypervisors. Where it is not possible to schedule all
  instances to separate hypervisors, they will be scheduled on as many
  separate hypervisors as possible.

There is currently one rule supported:

**max_server_per_host**

  Indicates the max number of instances that can be scheduled to any
  given hypervisor when using the anti-affinity policy. This rule is
  not compatible with other policies.


Usage
-----

.. IMPORTANT:: **Server Groups and memberships are immutable**
  Once a server group has been created, it cannot be modified. Also,
  an instance can not move between server groups.

Creating a server group "my-server-group" with
policy **soft-anti-affinity** and a rule that specifies maximum 2
instances per hypervisor:

.. clode-block:: console

  openstack server group create --policy soft-anti-affinity --rule max_server_per_host=2 my-server-group

An existing server group can be used when creating a server. Example:

.. code-block:: console

  openstack server create --hint group=my-server-group ... <NAME>

