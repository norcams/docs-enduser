# Region
region = "bgo"

# This is needed to access the instance over ssh
allow_ssh_from_v6 = [
  "2001:700:100:202::202:12/128",
  "2001:700:100:118::67/128"
]
allow_ssh_from_v4 = [
  "129.240.202.12/32",
  "129.240.118.67/32"
]

# This is needed to access the instance over http
allow_http_from_v6 = [
  "2001:700:100::/40"
]
allow_http_from_v4 = [
  "129.240.0.0/16"
]

# This is needed to access the instance over the mysql port
allow_mysql_from_v6 = [
  "2001:700:100:202::202:12/128"
]
allow_mysql_from_v4 = [
  "129.240.202.12/32"
]
