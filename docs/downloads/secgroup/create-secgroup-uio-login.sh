#!/bin/bash

# Name of security group. NB! No spaces
SECGROUP_NAME=ssh_icmp_from_login.uio.no

# Description of security group
SECGROUP_DESC="Allows ssh and ping from login hosts at UiO"

# CIDR addresses we want to open for
IPV4_NETWORKS=(
    "129.240.114.32/28"
    "129.240.114.48/28"
)
IPV6_NETWORKS=(
    "2001:700:100:8070::/64"
    "2001:700:100:8071::/64"
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

