module "vpc" {
  # forces ssh connection
  # // allows us to specify module directories
  # ref allows us to pin a module to a particular commit or tag
  # (terraform get -update will not update .terraform/modules )
  #source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git?ref=3c69a0ce//aws/vpc/"
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/vpc/"

  name        = var.name
  name_suffix = var.name_suffix

  vpc_cidr                        = var.vpc_cidr
  additional_vpc_ipv4_cidr_blocks = var.additional_vpc_ipv4_cidr_blocks
  public_subnets                  = var.public_subnets
  public_subnet_map_public_ip     = var.public_subnet_map_public_ip
  private_subnets                 = var.private_subnets
  private_subnet_map_public_ip    = var.private_subnet_map_public_ip
  region                          = var.region
  azs                             = var.azs

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  flow_log_type      = var.flow_log_type
  flow_log_retention = var.flow_log_retention

  propagte_vgws = var.propagte_vgws
  default_tags  = var.default_tags

  vpce_s3_policy        = var.vpce_s3_policy
  private_vpce_s3_route = var.private_vpce_s3_route
  public_vpce_s3_route  = var.public_vpce_s3_route
}

/* Common Public Ingress NACL rules (use rule num 0 - 2000)
*/

module "http_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  proto             = "tcp"
  from_port         = 80
  to_port           = 80
  rule_no           = 100
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "https_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  proto             = "tcp"
  from_port         = 443
  to_port           = 443
  rule_no           = 200
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "ssh_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.public_nacl_id
  egress    = false
  proto     = "tcp"
  from_port = 22
  to_port   = 22
  rule_no   = 300
  action    = "allow"
  cidr_blocks = [
    var.cidrs["piksel"],
    var.cidrs["piksel_jo_hide"],
    var.cidrs["c4_corp"],
    var.cidrs["c4_corp_wifi"],
    var.cidrs["c4_corp_dx"],
    var.vpc_cidr,
  ]
  cidr_blocks_count = 6
}

module "hightcp_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  proto             = "tcp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 400
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# for inbound ntp UDP requests
module "highudp_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  proto             = "udp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 500
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# allow dns egress from private subnets
module "dnstcp_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.public_nacl_id
  egress    = false
  proto     = "tcp"
  from_port = 53
  to_port   = 53
  rule_no   = 600
  action    = "allow"

  # as we list a public NS server in resolv we should allow them to respond
  #cidr_blocks = ["${var.vpc_cidr}"]
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "dnsudp_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.public_nacl_id
  egress    = false
  proto     = "udp"
  from_port = 53
  to_port   = 53
  rule_no   = 700
  action    = "allow"

  # as we list a public NS server in resolv we should allow them to respond
  #cidr_blocks = ["${var.vpc_cidr}"]
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# ntp queries from our ntp servers to anywhere
module "ntp_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  proto             = "udp"
  from_port         = 123
  to_port           = 123
  rule_no           = 800
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# icmp Time Exceed (to enable traceroute responses)
module "traceroute_pub_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_icmp_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = false
  icmp_type         = 11
  icmp_code         = "-1"
  rule_no           = 900
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

/* Common Public Egress NACL rules (use rule num 0 - 2000)
*/

module "http_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 80
  to_port           = 80
  rule_no           = 100
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "https_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 443
  to_port           = 443
  rule_no           = 200
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "hightcp_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 300
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "highudp_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "udp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 400
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "ntp_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "udp"
  from_port         = 123
  to_port           = 123
  rule_no           = 500
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# allow dns requests within VPC or extenrally
module "dnstcp_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 53
  to_port           = 53
  rule_no           = 600
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "dnsudp_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "udp"
  from_port         = 53
  to_port           = 53
  rule_no           = 700
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "ssh_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 22
  to_port           = 22
  rule_no           = 800
  action            = "allow"
  cidr_blocks       = [var.vpc_cidr]
  cidr_blocks_count = 1
}

# icmp Time Exceed (to enable traceroute responses)
module "traceroute_pub_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_icmp_rule/"

  nacl_id           = module.vpc.public_nacl_id
  egress            = true
  icmp_type         = 11
  icmp_code         = "-1"
  rule_no           = 900
  action            = "allow"
  cidr_blocks       = [var.vpc_cidr]
  cidr_blocks_count = 1
}

/* Common Private Ingress NACL rules (use rule num 0 - 2000)
*/

module "ssh_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.private_nacl_id
  egress    = false
  proto     = "tcp"
  from_port = 22
  to_port   = 22
  rule_no   = 100
  action    = "allow"
  cidr_blocks = [
    var.cidrs["piksel_jo_hide"],
    var.vpc_cidr,
  ]
  cidr_blocks_count = 2
}

# return trafifc from NAT gateway
module "hightcp_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = false
  proto             = "tcp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 200
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "highudp_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = false
  proto             = "udp"
  from_port         = 1024
  to_port           = 65535
  rule_no           = 300
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# dns service lives in private subnet
module "dnstcp_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.private_nacl_id
  egress    = false
  proto     = "tcp"
  from_port = 53
  to_port   = 53
  rule_no   = 400
  action    = "allow"
  cidr_blocks = concat(
    [
      var.vpc_cidr,
      var.cidrs["c4_th_dns"],
      var.cidrs["piksel_ns_hide"],
    ],
    var.additional_vpc_ipv4_cidr_blocks
  )
  cidr_blocks_count = 3 + length(var.additional_vpc_ipv4_cidr_blocks)
}

module "dnsudp_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.private_nacl_id
  egress    = false
  proto     = "udp"
  from_port = 53
  to_port   = 53
  rule_no   = 500
  action    = "allow"
  cidr_blocks = concat(
    [
      var.vpc_cidr,
      var.cidrs["c4_th_dns"],
      var.cidrs["piksel_ns_hide"],
    ],
    var.additional_vpc_ipv4_cidr_blocks
  )
  cidr_blocks_count = 3 + length(var.additional_vpc_ipv4_cidr_blocks)
}

module "ntp_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = false
  proto             = "udp"
  from_port         = 123
  to_port           = 123
  rule_no           = 600
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# icmp Time Exceed (to enable traceroute responses)
module "traceroute_priv_in_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_icmp_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = false
  icmp_type         = 11
  icmp_code         = "-1"
  rule_no           = 700
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

/* Common Private Egress NACL rules (use rule num 0 - 2000)
*/

module "http_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 80
  to_port           = 80
  rule_no           = 100
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "https_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 443
  to_port           = 443
  rule_no           = 200
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

# responses to public subnets
module "hightcp_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.private_nacl_id
  egress    = true
  proto     = "tcp"
  from_port = 1024
  to_port   = 65535
  rule_no   = 300
  action    = "allow"
  cidr_blocks = concat(
    [
      var.vpc_cidr,
      var.cidrs["c4_th_dns"],
      var.cidrs["piksel_ns_hide"],
      var.cidrs["piksel_jo_hide"],
    ],
    var.additional_vpc_ipv4_cidr_blocks
  )
  cidr_blocks_count = 4 + length(var.additional_vpc_ipv4_cidr_blocks)
}

module "highudp_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id   = module.vpc.private_nacl_id
  egress    = true
  proto     = "udp"
  from_port = 1024
  to_port   = 65535
  rule_no   = 400
  action    = "allow"
  cidr_blocks = concat(
    [
      var.vpc_cidr,
      var.cidrs["c4_th_dns"],
      var.cidrs["piksel_ns_hide"],
      var.cidrs["piksel_jo_hide"],
    ],
    var.additional_vpc_ipv4_cidr_blocks
  )
  cidr_blocks_count = 4 + length(var.additional_vpc_ipv4_cidr_blocks)
}

# dns to on-prem, .2 service or internet
module "dnstcp_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = true
  proto             = "tcp"
  from_port         = 53
  to_port           = 53
  rule_no           = 500
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "dnsudp_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = true
  proto             = "udp"
  from_port         = 53
  to_port           = 53
  rule_no           = 600
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}

module "ntp_priv_out_nacl_rule" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/nacl_rule/"

  nacl_id           = module.vpc.private_nacl_id
  egress            = true
  proto             = "udp"
  from_port         = 123
  to_port           = 123
  rule_no           = 700
  action            = "allow"
  cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks_count = 1
}
