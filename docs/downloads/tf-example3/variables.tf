# Variables
variable "region" { }
variable "name" { default = "myproject" }
variable "ssh_public_key" { default = "~/.ssh/id_rsa.pub" }
variable "network" { default = "IPv6" }
variable "volume_size" { default = 20 }

# Security group defaults
variable "allow_ssh_from_v6"   { type = "list" default = [] }
variable "allow_ssh_from_v4"   { type = "list" default = [] }
variable "allow_http_from_v6"  { type = "list" default = [] }
variable "allow_http_from_v4"  { type = "list" default = [] }
variable "allow_mysql_from_v6" { type = "list" default = [] }
variable "allow_mysql_from_v4" { type = "list" default = [] }

# Mapping between role and image
variable "role_image" {
  type = "map"
  default = {
    "web" = "4756b700-9489-4d59-bfd6-24d3b8b4167b"  # GOLD CentOS 7
    "db"  = "974d7df1-d845-4bf0-a3c0-d95d85267d43"  # GOLD Ubuntu 18.04 LTS
  }
}

# Mapping between role and flavor
variable "role_flavor" {
  type = "map"
  default = {
    "web" = "m1.small"
    "db"  = "m1.medium"
  }
}

# Mapping between role and number of instances (count)
variable "role_count" {
  type = "map"
  default = {
    "web" = 4
    "db"  = 1
  }
}
