variable "route_table_ids" {
  type        = list(string)
  description = "List of route table ids to add a route to"
}

variable "destination_cidr" {
  description = "Destination CIDR of route"
}

variable "target_type" {
  description = "One of [vpc-peering-connection-id|gateway-id|nat-gateway-id|instance-id|network-interface-id] see http://docs.aws.amazon.com/cli/latest/reference/ec2/create-route.html"
}

variable "target_value" {
  description = "Target of route"
}

variable "profile" {
  description = "Profile to use when adding route"
}

