provider "openstack" {
}

resource "openstack_dns_zone_v2" "test_com" {
  name        = "test.com."
  email       = "trondham@uio.no"
  description = "An example zone"
}
