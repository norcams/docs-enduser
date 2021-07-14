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

resource "openstack_dns_zone_v2" "test_com" {
  name        = "test.com."
  email       = "trondham@uio.no"
  description = "An example zone"
}
