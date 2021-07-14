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
resource "openstack_compute_keypair_v2" "keypair" {
  region     = var.region
  name       = "${terraform.workspace}-${var.name}"
  public_key = file(var.ssh_public_key)
}

# Web servers
resource "openstack_compute_instance_v2" "web_instance" {
  region      = var.region
  count       = lookup(var.role_count, "web", 0)
  name        = "${var.region}-web-${count.index}"
  image_name  = lookup(var.role_image, "web", "unknown")
  flavor_name = lookup(var.role_flavor, "web", "unknown")

  key_pair = "${terraform.workspace}-${var.name}"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-web",
  ]

  network {
    name = "IPv6"
  }

  metadata = {
    ssh_user       = lookup(var.role_ssh_user, "web", "unknown")
    prefer_ipv6    = 1
    my_server_role = "web"
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_web_access,
  ]
}

# Database servers
resource "openstack_compute_instance_v2" "db_instance" {
  region      = var.region
  count       = lookup(var.role_count, "db", 0)
  name        = "${var.region}-db-${count.index}"
  image_name  = lookup(var.role_image, "db", "unknown")
  flavor_name = lookup(var.role_flavor, "db", "unknown")

  key_pair = "${terraform.workspace}-${var.name}"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-db",
  ]

  network {
    name = "IPv6"
  }

  metadata = {
    ssh_user       = lookup(var.role_ssh_user, "db", "unknown")
    prefer_ipv6    = 1
    python_bin     = "/usr/bin/python3"
    my_server_role = "database"
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_db_access,
  ]
}

# Volume
resource "openstack_blockstorage_volume_v2" "volume" {
  name = "database"
  size = var.volume_size
}

# Attach volume
resource "openstack_compute_volume_attach_v2" "attach_vol" {
  instance_id = openstack_compute_instance_v2.db_instance[0].id
  volume_id   = openstack_blockstorage_volume_v2.volume.id
}
