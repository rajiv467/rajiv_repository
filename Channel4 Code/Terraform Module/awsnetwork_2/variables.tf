/* Network
*/

variable "name" {
  description = "name"
}

variable "name_suffix" {
  description = "name suffix"
}

variable "cidrs" {
  type        = map(string)
  description = "Map of known CIDR blocks"
}

variable "vpc_cidr" {
  description = "vpc_cidr"
}

variable "additional_vpc_ipv4_cidr_blocks" {
  description = "Additional IPv4 CIDR blocks to associate with the VPC"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "az region suffix"
}

variable "public_subnets" {
  description = "Comma seperated list of CIDR blocks to apply to public subnets"
}

variable "public_subnet_map_public_ip" {
  description = "Map public IP on EC2 launch in public subnets (default: false)"
  default     = false
}

variable "private_subnets" {
  description = "Comma seperated list of CIDR blocks to apply to private subnets"
}

variable "private_subnet_map_public_ip" {
  description = "Map public IP on EC2 launch in private subnets (default: false)"
  default     = false
}

variable "azs" {
  description = "AZ suffix to append to region variable to determine where subnets are created (default: \"a,b\")"
  #default = "a,b"
}

variable "enable_dns_hostnames" {
  description = "Whether or not to enable DNS hostnames on VPC (default: true)"
  default     = true
}

variable "enable_dns_support" {
  description = "Whether or not to enable DNS support on VPC (default: true)"
  default     = true
}

variable "flow_log_type" {
  description = "Capture (ACCEPT|REJECT|ALL) traffic"
  default     = "ALL"
}

variable "flow_log_retention" {
  description = "Number of days to keep flow logs"
  default     = 90
}

variable "propagte_vgws" {
  type        = list(string)
  description = "List of VGWs to propagate routes for"
  default     = [""]
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

variable "vpce_s3_policy" {
  description = "Policy to add to the S3 VPCE"
  default     = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Principal": "*",
            "Action":"*",
            "Resource":"*"
        }
    ]
}
EOF

}

variable "private_vpce_s3_route" {
  description = "Bool: Whether to add a route for S3 VPCE on the Private subnet route tables (Default: true)"
  default     = true
}

variable "public_vpce_s3_route" {
  description = "Bool: Whether to add a route for S3 VPCE on the Public subnet route tables (Default: true)"
  default     = true
}

