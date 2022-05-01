variable "nacl_id" {
  description = "NACL Object to create rule in"
}

variable "egress" {
  description = "Whether rule is an egress rule"
}

variable "proto" {
  description = "Rule protocol (tcp|udp)"
}

variable "from_port" {
  description = "Rule from port"
}

variable "to_port" {
  description = "Rule to port"
}

variable "rule_no" {
  description = "Base rule number to apply to rule"
}

variable "action" {
  description = "Rule action (allow|deny)"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks. Creates a rule per block."
}

variable "cidr_blocks_count" {
  description = "Count of number of cidr block input required due to bug https://github.com/hashicorp/terraform/issues/3888"
}
