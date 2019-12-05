resource "openstack_dns_recordset_v2" "A_test01_tralala_no" {
  zone_id     = openstack_dns_zone_v2.tralala_no.id
  name        = "test01.tralala.no."
  description = "An example record set"
  type        = "A"
  records     = ["10.0.0.1"]
}

resource "openstack_dns_recordset_v2" "AAAA_test01_tralala_no" {
  zone_id     = openstack_dns_zone_v2.tralala_no.id
  name        = "test01.tralala.no."
  description = "An example record set"
  type        = "AAAA"
  records     = ["2001:700:2:8200::226c"]
}

resource "openstack_dns_recordset_v2" "CNAME_www_tralala_no" {
  zone_id     = openstack_dns_zone_v2.tralala_no.id
  name        = "www.tralala.no."
  description = "An example record set"
  type        = "CNAME"
  records     = ["test01.tralala.no."]
}
