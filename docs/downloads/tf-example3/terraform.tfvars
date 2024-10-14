# Region
region = "osl"

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
  "2001:700:100:8070::/64",
  "2001:700:100:8071::/64"
]
allow_ssh_from_v4 = [
  "129.240.114.32/28",
  "129.240.114.48/28"
]

# This is needed to access the instance over http
allow_http_from_v6 = [
  "2001:700:200::/48",
  "2001:700:100::/41"
]
allow_http_from_v4 = [
  "129.177.0.0/16",
  "129.240.0.0/16"
]

# This is needed to access the instance over the mysql port
allow_mysql_from_v6 = [
  "2001:700:100:4003::43/128"
]
allow_mysql_from_v4 = [
  "129.240.130.12/32"
]
