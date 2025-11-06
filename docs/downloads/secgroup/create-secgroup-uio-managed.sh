#!/bin/bash

# Name of security group. NB! No spaces
SECGROUP_NAME=uio_managed_v1

# Description of security group
SECGROUP_DESC="Minimal requirement for UiO Managed (v1)"

# CIDR addresses we want to open for
IPV4_CORE_NETWORKS=(
    "129.240.2.0/27"
    "129.240.2.32/27"
    "129.240.2.64/27"
)
IPV6_CORE_NETWORKS=(
    "2001:700:100:2::/64"
    "2001:700:100:425::/64"
    "2001:700:100:540::/64"
)
IPV4_UIO_NETWORKS=(
    "129.240.0.0/16"
    "78.91.122.0/23"
)
IPV6_UIO_NETWORKS=(
    "2001:700:100::/40"
    "2001:700:2:8c00::/64"
    "2001:700:2:8c01::/64"
    "2001:700:2:8c21::/64"
)
IPV4_LDAP="129.240.2.124"
IPV4_SMTP="129.240.2.125"

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

# Remove existing security group rules
for rule in $(openstack security group rule list $SECGROUP_NAME -c ID -f value); do
    openstack security group rule delete $rule
done

# Create rules for core networks
for cidr in ${IPV4_CORE_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv4 --protocol any --ingress \
              --remote-ip $cidr $SECGROUP_NAME
    openstack security group rule create --ethertype IPv4 --protocol any --egress \
              --remote-ip $cidr $SECGROUP_NAME
done
for cidr in ${IPV6_CORE_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv6 --protocol any --ingress \
              --remote-ip $cidr $SECGROUP_NAME
    openstack security group rule create --ethertype IPv6 --protocol any --egress \
              --remote-ip $cidr $SECGROUP_NAME
done

# Create rules for single hosts
openstack security group rule create --remote-ip $IPV4_LDAP --ethertype IPv4 \
	  --protocol tcp --dst-port 636 --egress $SECGROUP_NAME
openstack security group rule create --remote-ip $IPV4_LDAP --ethertype IPv4 \
	  --protocol tcp --dst-port 389 --egress $SECGROUP_NAME
openstack security group rule create --remote-ip $IPV4_SMTP --ethertype IPv4 \
	  --protocol tcp --dst-port 25 --egress $SECGROUP_NAME

# Create ingress ICMP rules
for cidr in ${IPV4_UIO_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv4 --protocol icmp --ingress \
              --remote-ip $cidr $SECGROUP_NAME
done
for cidr in ${IPV6_UIO_NETWORKS[@]}; do
    openstack security group rule create --ethertype IPv6 --protocol ipv6-icmp --ingress \
              --remote-ip $cidr $SECGROUP_NAME
done

# Create egress ICMP rules
openstack security group rule create --remote-ip 0.0.0.0/0 --ethertype IPv4 \
	  --protocol icmp --egress $SECGROUP_NAME
openstack security group rule create --remote-ip ::/0 --ethertype IPv6 \
	  --protocol ipv6-icmp --egress $SECGROUP_NAME
