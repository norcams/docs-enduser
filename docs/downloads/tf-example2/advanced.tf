# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

# Configure the OpenStack Provider
# Empty means using environment variables "OS_*". More info:
# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
provider "openstack" {}

# SSH key
resource "openstack_compute_keypair_v2" "my-terraform-key" {
  name = "my-terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security group
resource "openstack_networking_secgroup_v2" "instance_access" {
  name = "uio-ssh-icmp"
  description = "Allow SSH and ICMP access from UiO"
}

# Allow ssh from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "129.240.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.instance_access.id
}

# Allow ssh from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv6" {
  direction = "ingress"
  ethertype = "IPv6"
  protocol  = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "2001:700:100::/41"
  security_group_id = openstack_networking_secgroup_v2.instance_access.id
}

# Allow icmp from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "icmp"
  remote_ip_prefix = "129.240.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.instance_access.id
}

# Allow icmp from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv6" {
  direction = "ingress"
  ethertype = "IPv6"
  protocol = "ipv6-icmp"
  remote_ip_prefix = "2001:700:100::/41"
  security_group_id = openstack_networking_secgroup_v2.instance_access.id
}

# Instances
resource "openstack_compute_instance_v2" "instance" {
  count = 5
  name = "test-${count.index}"
  image_name = "GOLD CentOS 8"
  flavor_name = "m1.small"

  key_pair = "my-terraform-key"
  security_groups = [ "default", "uio-ssh-icmp" ]

  network {
    name = "IPv6"
  }

  lifecycle {
    ignore_changes = [image_name]
  }
}

# Volume
resource "openstack_blockstorage_volume_v2" "volume" {
  name = "my-volume"
  size = "10"
}

# Attach volume
resource "openstack_compute_volume_attach_v2" "volumes" {
  instance_id = openstack_compute_instance_v2.instance.0.id
  volume_id   = openstack_blockstorage_volume_v2.volume.id
}
