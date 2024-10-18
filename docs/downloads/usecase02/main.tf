# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}
provider "openstack" {}

# SSH key
resource "openstack_compute_keypair_v2" "keypair" {
  region     = var.region
  name       = "${var.name}-key"
  public_key = file(var.ssh_public_key)
}

# Student servers
resource "openstack_compute_instance_v2" "student_instance" {
  region      = var.region
  count       = lookup(var.role_count, "students", 0)
  name        = "${var.name}-lab-${count.index}"
  image_name  = lookup(var.role_image, "snapshot", "unknown")
  flavor_name = lookup(var.role_flavor, "flavor", "unknown")

  key_pair = "${var.name}-key"
  security_groups = [
    "${var.name}-icmp",
    "${var.name}-ssh",
  ]

  network {
    name = "${var.network}"
  }

  lifecycle {
    ignore_changes = [image_name,image_id]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_icmp_access,
    openstack_networking_secgroup_v2.instance_ssh_access,
  ]
}

# Ansible student hosts
resource "ansible_host" "student_instance" {
  count  = lookup(var.role_count, "students", 0)
  name   = "${var.name}-lab-${count.index}"
  groups = ["${var.name}"] # Groups this host is part of

  variables = {
    ansible_host = trim(openstack_compute_instance_v2.student_instance[count.index].access_ip_v6, "[]")
  }
}

# Ansible student group
resource "ansible_group" "student_instances_group" {
  name     = "student_instances"
  children = ["${var.name}"]
  variables = {
    ansible_user = "almalinux"
    ansible_connection = "ssh"
  }
}
