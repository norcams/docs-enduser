provider "openstack" {}

# SSH key
resource "openstack_compute_keypair_v2" "keypair" {
    region = "${var.region}"
    name = "${terraform.workspace}-${var.name}"
    public_key = "${file(var.ssh_public_key)}"
}

# Web servers
resource "openstack_compute_instance_v2" "web_instance" {
    region = "${var.region}"
    count = "${lookup(var.role_count, "web", 0)}"
    name = "${var.region}-web-${count.index}"
    image_name = "${lookup(var.role_image, "web", "unknown")}"
    flavor_name = "${lookup(var.role_flavor, "web", "unknown")}"

    key_pair = "${terraform.workspace}-${var.name}"
    security_groups = [
        "default",
        "${terraform.workspace}-${var.name}-ssh",
        "${terraform.workspace}-${var.name}-web"
    ]

    network {
        name = "IPv6"
    }

    depends_on = [
        "openstack_networking_secgroup_v2.instance_ssh_access",
        "openstack_networking_secgroup_v2.instance_web_access"
    ]
}

# Database servers
resource "openstack_compute_instance_v2" "db_instance" {
    region = "${var.region}"
    count = "${lookup(var.role_count, "db", 0)}"
    name = "${var.region}-db-${count.index}"
    image_name = "${lookup(var.role_image, "db", "unknown")}"
    flavor_name = "${lookup(var.role_flavor, "db", "unknown")}"

    key_pair = "${terraform.workspace}-${var.name}"
    security_groups = [
        "default",
        "${terraform.workspace}-${var.name}-ssh",
        "${terraform.workspace}-${var.name}-db"
    ]

    network {
        name = "IPv6"
    }

    depends_on = [
        "openstack_networking_secgroup_v2.instance_ssh_access",
        "openstack_networking_secgroup_v2.instance_db_access"
    ]
}

# Volume
resource "openstack_blockstorage_volume_v2" "volume" {
    name = "database"
    size = ${var.volume_size}
}

# Attach volume
resource "openstack_compute_volume_attach_v2" "attach_vol" {
    instance_id = "${openstack_compute_instance_v2.db_instance.id}"
    volume_id   = "${openstack_blockstorage_volume_v2.volume.id}"
}
