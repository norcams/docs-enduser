# Allow MYSQL from web servers (IPv4)
resource "openstack_networking_secgroup_rule_v2" "rule2_mysql_access_ipv4" {
  region         = var.region
  count          = lookup(var.role_count, "web", 0)
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = 3306
  port_range_max = 3306
  remote_ip_prefix = "${element(
    openstack_compute_instance_v2.web_instance.*.access_ip_v4,
    count.index,
  )}/32"
  security_group_id = openstack_networking_secgroup_v2.instance_db_access.id
  depends_on        = [openstack_compute_instance_v2.web_instance]
}

# Allow MYSQL from web servers (IPv6)
resource "openstack_networking_secgroup_rule_v2" "rule2_mysql_access_ipv6" {
  region         = var.region
  count          = lookup(var.role_count, "web", 0)
  direction      = "ingress"
  ethertype      = "IPv6"
  protocol       = "tcp"
  port_range_min = 3306
  port_range_max = 3306
  remote_ip_prefix = "${replace(
    element(
      openstack_compute_instance_v2.web_instance.*.access_ip_v6,
      count.index,
    ),
    "/[\\[\\]]/",
    "",
  )}/128"
  security_group_id = openstack_networking_secgroup_v2.instance_db_access.id
  depends_on        = [openstack_compute_instance_v2.web_instance]
}

