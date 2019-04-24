provider "openstack" {}

# Security group
resource "openstack_networking_secgroup_v2" "instance_access" {
  name = "ssh-and-icmp"
  description = "Security group for allowing SSH and ICMP access"
}

# Allow ssh from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv4" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = 22
    port_range_max = 22
    remote_ip_prefix = "129.240.0.0/16"
    security_group_id = "${openstack_networking_secgroup_v2.instance_access.id}"
}

# Allow ssh from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv6" {
    direction = "ingress"
    ethertype = "IPv6"
    protocol = "tcp"
    port_range_min = 22
    port_range_max = 22
    remote_ip_prefix = "2001:700:100::/40"
    security_group_id = "${openstack_networking_secgroup_v2.instance_access.id}"
}

# Allow icmp from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv4" {
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "icmp"
    remote_ip_prefix = "129.240.0.0/16"
    security_group_id = "${openstack_networking_secgroup_v2.instance_access.id}"
}

# Allow icmp from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv6" {
    direction = "ingress"
    ethertype = "IPv6"
    protocol = "icmp"
    remote_ip_prefix = "2001:700:100::/40"
    security_group_id = "${openstack_networking_secgroup_v2.instance_access.id}"
}

# Instances
resource "openstack_compute_instance_v2" "example" {
  count = 5
  name = "test-${count.index}"
  image_name = "GOLD CentOS 7"
  flavor_name = "m1.small"

  key_pair = "mykey"
  security_groups = [ "default", "ssh-and-icmp" ]

  network {
    name = "IPv6"
  }
}
