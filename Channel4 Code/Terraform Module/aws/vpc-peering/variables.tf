variable "requester_account_id" {
}

variable "requester_aws_profile" {
}

variable "requester_aws_region" {
}

variable "requester_vpc_id" {
}

variable "requester_vpc_cidr" {
}

variable "requester_vpc_route_tables_count" {
}

variable "requester_vpc_route_tables" {
  type = list(string)
}

variable "acceptor_account_id" {
}

variable "acceptor_aws_profile" {
}

variable "acceptor_aws_region" {
}

variable "acceptor_vpc_id" {
}

variable "acceptor_vpc_cidr" {
}

variable "acceptor_vpc_route_tables_count" {
}

variable "acceptor_vpc_route_tables" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

