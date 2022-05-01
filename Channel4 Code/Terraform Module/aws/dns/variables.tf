variable "phz_name" {
  description = "Private Hosted Zone name"
}

variable "hz_name" {
  description = "Public Hosted Zone name"
}

variable "name_suffix" {
  description = "Object name suffix"
}

variable "vpc_id" {
  description = "VPC Id to initially associate with PHZ"
}

variable "main_zone_id" {
  description = "Zone Id to add Public Hosted Zone deligation set to"
}

variable "main_zone_name" {
  description = "Zone Name to add Public Hosted Zone deligation set to"
}

variable "main_zone_profile" {
  description = "Profile to use when adding delegation set to main zone"
}

variable "sg_dns_id" {
  description = "DNS security groups"
}

variable "private_subnets" {
  type        = list(string)
  description = "VPC private subnets"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "VPC provate subnets CIDR"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "subdomain_name" {
  description = "Subdomain/Environment name"
}

variable "default_tags" {
  type        = map(string)
  description = "Resource default tags"
}

variable "cidrs" {
  type        = map(string)
  description = "Accounts CIDRs"
  default     = {}
}

variable "domain_name" {
  description = "Main domain name"
}

variable "target_ip_1" {
  description = "First target IP to forward DNS queries to"
}

variable "target_ip_2" {
  description = "Second target IP to forward DNS queries to"
}

variable "outbound_forward_domains" {
  type        = list(string)
  description = "List of targeted domains"
}

