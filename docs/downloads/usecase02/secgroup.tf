# Security group ICMP
resource "openstack_networking_secgroup_v2" "instance_icmp_access" {
  region      = var.region
  name        = "${var.name}-icmp"
  description = "Security group for allowing ICMP access"
}

# Security group SSH
resource "openstack_networking_secgroup_v2" "instance_ssh_access" {
  region      = var.region
  name        = "${var.name}-ssh"
  description = "Security group for allowing SSH access"
}

# Allow ssh from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv4" {
  region            = var.region
  count             = length(var.allow_ssh_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.allow_ssh_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow ssh from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv6" {
  region            = var.region
  count             = length(var.allow_ssh_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.allow_ssh_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow icmp from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv4" {
  region            = var.region
  count             = length(var.allow_icmp_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.allow_icmp_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_icmp_access.id
}

# Allow icmp from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv6" {
  region            = var.region
  count             = length(var.allow_icmp_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_ip_prefix  = var.allow_icmp_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_icmp_access.id
}
