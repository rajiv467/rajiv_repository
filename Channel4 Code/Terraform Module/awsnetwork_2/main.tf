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

## Private
resource "aws_default_network_acl" "default_private" {
  default_network_acl_id = module.vpc.private_nacl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
## Public
resource "aws_default_network_acl" "default_public" {
  default_network_acl_id = module.vpc.public_nacl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
