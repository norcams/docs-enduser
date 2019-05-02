# Security group SSH + ICMP
resource "openstack_networking_secgroup_v2" "instance_ssh_access" {
    region = "${var.region}"
    name = "${terraform.workspace}-${var.name}-ssh"
    description = "Security group for allowing SSH and ICMP access"
}

# Security group HTTP
resource "openstack_networking_secgroup_v2" "instance_web_access" {
    region = "${var.region}"
    name = "${terraform.workspace}-${var.name}-web"
    description = "Security group for allowing HTTP access"
}

# Security group MySQL
resource "openstack_networking_secgroup_v2" "instance_db_access" {
    region = "${var.region}"
    name = "${terraform.workspace}-${var.name}-db"
    description = "Security group for allowing MySQL access"
}

# Allow ssh from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule1_ssh_access_ipv4" {
    region = "${var.region}"
    count = "${length(var.allow_ssh_from_v4)}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 22
    port_range_max = 22
    remote_ip_prefix = "${var.allow_ssh_from_v4[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_ssh_access.id}"
}

# Allow ssh from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule1_ssh_access_ipv6" {
    region = "${var.region}"
    count = "${length(var.allow_ssh_from_v6)}"
    direction = "ingress"
    ethertype = "IPv6"
    protocol  = "tcp"
    port_range_min = 22
    port_range_max = 22
    remote_ip_prefix = "${var.allow_ssh_from_v6[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_ssh_access.id}"
}

# Allow icmp from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule1_icmp_access_ipv4" {
    region = "${var.region}"
    count = "${length(var.allow_ssh_from_v4)}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "icmp"
    remote_ip_prefix = "${var.allow_ssh_from_v4[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_ssh_access.id}"
}

# Allow icmp from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule1_icmp_access_ipv6" {
    region = "${var.region}"
    count = "${length(var.allow_ssh_from_v6)}"
    direction = "ingress"
    ethertype = "IPv6"
    protocol = "icmp"
    remote_ip_prefix = "${var.allow_ssh_from_v6[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_ssh_access.id}"
}

# Allow HTTP from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule1_http_access_ipv4" {
    region = "${var.region}"
    count = "${length(var.allow_http_from_v4)}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 80
    port_range_max = 80
    remote_ip_prefix = "${var.allow_http_from_v4[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_web_access.id}"
}

# Allow HTTP from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule1_http_access_ipv6" {
    region = "${var.region}"
    count = "${length(var.allow_http_from_v6)}"
    direction = "ingress"
    ethertype = "IPv6"
    protocol  = "tcp"
    port_range_min = 80
    port_range_max = 80
    remote_ip_prefix = "${var.allow_http_from_v6[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_web_access.id}"
}

# Allow MySQL from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule1_mysql_access_ipv4" {
    region = "${var.region}"
    count = "${length(var.allow_mysql_from_v4)}"
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 3306
    port_range_max = 3306
    remote_ip_prefix = "${var.allow_mysql_from_v4[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_db_access.id}"
}

# Allow MYSQL from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule1_mysql_access_ipv6" {
    region = "${var.region}"
    count = "${length(var.allow_mysql_from_v6)}"
    direction = "ingress"
    ethertype = "IPv6"
    protocol  = "tcp"
    port_range_min = 3306
    port_range_max = 3306
    remote_ip_prefix = "${var.allow_mysql_from_v6[count.index]}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_db_access.id}"
}

# Allow MYSQL from web servers (IPv4)
resource "openstack_networking_secgroup_rule_v2" "rule_mysql_from_web_access_ipv4" {
    region = "${var.region}"
    count = 1
    direction = "ingress"
    ethertype = "IPv4"
    protocol  = "tcp"
    port_range_min = 3306
    port_range_max = 3306
    remote_group_id = "${openstack_networking_secgroup_v2.instance_web_access.id}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_db_access.id}"
}

# Allow MYSQL from web servers (IPv6)
resource "openstack_networking_secgroup_rule_v2" "rule_mysql_from_web_access" {
    region = "${var.region}"
    count = 1
    direction = "ingress"
    ethertype = "IPv6"
    protocol  = "tcp"
    port_range_min = 3306
    port_range_max = 3306
    remote_group_id = "${openstack_networking_secgroup_v2.instance_web_access.id}"
    security_group_id = "${openstack_networking_secgroup_v2.instance_db_access.id}"
}
