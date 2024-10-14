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

# Create a server
resource "openstack_compute_instance_v2" "test-server" {
  name = "test-server"
  image_name = "GOLD Alma Linux 9"
  flavor_name = "m1.small"

  key_pair = "mykey"
  security_groups = [ "default", "ssh_icmp_login.uio.no" ]

  network {
    name = "IPv6"
  }
}
