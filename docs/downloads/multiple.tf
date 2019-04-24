provider "openstack" {}

resource "openstack_compute_instance_v2" "example" {
  count = 5
  name = "test-${count.index}"
  image_name = "GOLD CentOS 7"
  flavor_name = "m1.small"

  key_pair = "mykey"
  security_groups = [ "default", "SSH and ICMP" ]

  network {
    name = "IPv6"
  }
}
