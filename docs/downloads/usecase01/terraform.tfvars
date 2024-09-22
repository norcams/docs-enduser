# Region
region = "osl"

# This is needed for ICMP access
allow_icmp_from_v6 = [
  "2001:700:100::/48"
]
allow_icmp_from_v4 = [
  "129.240.0.0/16"
]

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
  "2001:700:100:8070::/64",
  "2001:700:100:8071::/64",
]
allow_ssh_from_v4 = [
  "129.240.114.32/28",
  "129.240.114.48/28",
]

# This is needed to access the instance over RDP
allow_rdp_from_v6 = [
  "2001:700:100::/48"
]
allow_rdp_from_v4 = [
  "129.240.0.0/16"
]
