#!/bin/bash

# Name of security group. NB! No spaces
SECGROUP_NAME=ssh_icmp_from_uh_sector

# Description of security group
SECGROUP_DESC="Allows ssh and ping from Norwegian UH sector"

# CIDR addresses we want to open for
IPV4_NETWORKS=(
    "78.91.0.0/16"
    "84.38.14.0/24"
    "109.105.125.0/25"
    "128.39.0.0/16"
    "129.177.0.0/16"
    "129.240.0.0/16"
    "129.241.0.0/16"
    "129.242.0.0/16"
    "144.164.0.0/16"
    "151.157.0.0/16"
    "152.94.0.0/16"
    "157.249.0.0/16"
    "158.36.0.0/14"
    "161.4.0.0/16"
    "192.111.33.0/24"
    "192.133.32.0/24"
    "192.146.238.0/23"
    "193.156.0.0/15"
)
IPV6_NETWORKS=(
    "2001:700::/32"
)

# Check if security group already exists, and if so exit
openstack security group show $SECGROUP_NAME >/dev/null 2>&1
secgroup_return_code=$?
if [ $secgroup_return_code -eq 0 ]; then
    echo "ERROR: Security group $SECGROUP_NAME already exists!" >&2
    exit 1
fi

# Exit on error
set -e

# Create security group
openstack security group create --description "$SECGROUP_DESC" $SECGROUP_NAME

# Create IPv4 rules
for cidr in ${IPV4_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv4 --protocol icmp \
	      --remote-ip $cidr $SECGROUP_NAME
    openstack security group rule create --ethertype IPv4 --protocol tcp --dst-port 22 \
	      --remote-ip $cidr $SECGROUP_NAME
done

# Create IPv6 rules
for cidr in ${IPV6_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv6 --protocol ipv6-icmp \
	      --remote-ip $cidr $SECGROUP_NAME
    openstack security group rule create --ethertype IPv6 --protocol tcp --dst-port 22 \
	      --remote-ip $cidr $SECGROUP_NAME
done

