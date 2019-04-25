# Variables
variable "region" { }
variable "role" { default = "base" }
variable "name" { default = "myproject" }
variable "count" { default = 1 }
variable "allow_ssh_from_v6" { type = "list" default = [] }
variable "allow_ssh_from_v4" { type = "list" default = [] }
variable "ssh_public_key" { default = "~/.ssh/id_rsa.pub" }
variable "flavor_name" { default = "m1.small" }
variable "network" { default = "IPv6" }
variable "volume_size" { default = 10 }
variable "az" { default = "default-1" }
variable "metadata" { type = "map" default = {}}

variable "gold_images" { 
  type = "list" 
  default = [
    "GOLD CentOS 7",
    "GOLD Ubuntu 18.04 LTS"
  ]
}
variable "image_names" {
  type = "map"
  default = {
    "GOLD CentOS 7" = "centos7"
    "GOLD Ubuntu 18.04 LTS" = "ubuntu1804"
  }
}
variable "image_users" {
  type = "map"
  default = {
    "GOLD CentOS 7" = "centos"
    "GOLD Ubuntu 18.04 LTS" = "ubuntu"
  }
}