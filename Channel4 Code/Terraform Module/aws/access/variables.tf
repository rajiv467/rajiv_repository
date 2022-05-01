variable "name_suffix" {
  description = "name suffix"
}

variable "cidrs" {
  type        = map(string)
  description = "Map of known CIDR blocks"
}

variable "vpc_id" {
  description = "VPC Id"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
}

variable "additional_vpc_ipv4_cidr_blocks" {
  type        = list(string)
  description = "List of additional VPC IPv4 CIDR blocks"

  default = []
}

variable "saml_metadata" {
  description = "SAML Metadata document to create Idp"
}

variable "ansiblesrc_s3_arn" {
  description = "S3 arn used to create EC2 bootstrap access"
}

variable "tf_key_pub" {
  description = "Public SSH key used to do remote provisioning"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}
