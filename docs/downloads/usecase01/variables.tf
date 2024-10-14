# Variables
variable "region" {
}

variable "name" {
  default = "in9999-h2024"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_ed25519.pub"
}

variable "network" {
  default = "IPv6"
}

# Security group defaults
variable "allow_icmp_from_v6" {
  type    = list(string)
  default = []
}

variable "allow_icmp_from_v4" {
  type    = list(string)
  default = []
}

variable "allow_ssh_from_v6" {
  type    = list(string)
  default = []
}

variable "allow_ssh_from_v4" {
  type    = list(string)
  default = []
}

variable "allow_rdp_from_v6" {
  type    = list(string)
  default = []
}

variable "allow_rdp_from_v4" {
  type    = list(string)
  default = []
}

# Mapping between role and image
variable "role_image" {
  type = map(string)
  default = {
    "snapshot" = "master-snap-01"
  }
}

# Mapping between role and flavor
variable "role_flavor" {
  type = map(string)
  default = {
    "flavor" = "d1.medium"
  }
}

# Mapping between role and number of instances (count)
variable "role_count" {
  type = map(string)
  default = {
    "students" = 5
  }
}
