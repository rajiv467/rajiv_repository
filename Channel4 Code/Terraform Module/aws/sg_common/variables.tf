variable "name_suffix" {
  description = "Object name suffix"
}

variable "vpc_id" {
  description = "VPC if to create common Security Groups in"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
}

variable "additional_vpc_ipv4_cidr_blocks" {
  type        = list(string)
  description = "List of additional VPC IPv4 CIDR blocks"

  default = []
}

variable "cidrs" {
  type        = map(string)
  description = "Map of known CIDR blocks"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

