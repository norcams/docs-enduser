provider "openstack" {
}

resource "openstack_dns_zone_v2" "tralala_no" {
  name        = "tralala.no."
  email       = "trondham@uio.no"
  description = "An example zone"
}
