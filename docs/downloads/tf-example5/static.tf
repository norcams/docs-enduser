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

# Create zone
resource "openstack_dns_zone_v2" "test_com" {
  name        = "test.com."
  email       = "trondham@uio.no"
  description = "An example zone"
}

# Create A record
resource "openstack_dns_recordset_v2" "A_test01_test_com" {
  zone_id     = openstack_dns_zone_v2.test_com.id
  name        = "test01.test.com."
  description = "An example record set"
  type        = "A"
  records     = [ "10.0.0.1" ]
}

# Create AAAA record
resource "openstack_dns_recordset_v2" "AAAA_test01_test_com" {
  zone_id     = openstack_dns_zone_v2.test_com.id
  name        = "test01.test.com."
  description = "An example record set"
  type        = "AAAA"
  records     = [ "2001:700:2:8200::226c" ]
}

# Create CNAME record
resource "openstack_dns_recordset_v2" "CNAME_www_test_com" {
  zone_id     = openstack_dns_zone_v2.test_com.id
  name        = "www.test.com."
  description = "An example record set"
  type        = "CNAME"
  records     = [ "test01.test.com." ]
}
