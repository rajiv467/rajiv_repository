variable "name" {
  description = "Object name prefix"
}

variable "name_suffix" {
  description = "Object name suffix"
}

variable "vpc_cidr" {
  description = "CIDR block to aply to VPC"
}

variable "additional_vpc_ipv4_cidr_blocks" {
  description = "Additional IPv4 CIDR blocks to associate with the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "Comma seperated list of CIDR blocks to apply to public subnets"
}

variable "public_subnet_map_public_ip" {
  description = "Map public IP on EC2 launch in public subnets"
}

variable "private_subnets" {
  description = "Comma seperated list of CIDR blocks to apply to private subnets"
}

variable "private_subnet_map_public_ip" {
  description = "Map public IP on EC2 launch in private subnets"
}

variable "azs" {
  description = "AZ suffix to append to $${var.region} to determine where subnets are created"
}

variable "region" {
  description = "AWS region to append to $${var.azs}"
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
}

variable "flow_log_type" {
  description = "Capture (ACCEPT|REJECT|ALL) traffic"
}

variable "flow_log_retention" {
  description = "Number of days to keep flow logs"
}

variable "propagte_vgws" {
  type        = list(string)
  description = "List of VGWs to propagate routes for"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

variable "vpce_s3_policy" {
  description = "Policy to add to the S3 VPCE"
}

variable "private_vpce_s3_route" {
  description = "Whether to add a route for S3 VPCE on the Private subnet route tables"
}

variable "public_vpce_s3_route" {
  description = "Whether to add a route for S3 VPCE on the Public subnet route tables"
}

