provider "aws" {
  alias   = "requester"
  profile = var.requester_aws_profile
  region  = var.requester_aws_region
}

provider "aws" {
  alias   = "acceptor"
  profile = var.acceptor_aws_profile
  region  = var.acceptor_aws_region
}

resource "aws_vpc_peering_connection" "requester" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_owner_id = var.acceptor_account_id
  peer_vpc_id   = var.acceptor_vpc_id
  peer_region   = var.acceptor_aws_region
  auto_accept   = false
  tags          = var.tags
}

resource "aws_vpc_peering_connection_accepter" "acceptor" {
  provider                  = aws.acceptor
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
  auto_accept               = true
  tags                      = var.tags
}

resource "aws_route" "requester_to_acceptor" {
  provider                  = aws.requester
  count                     = var.requester_vpc_route_tables_count
  route_table_id            = element(var.requester_vpc_route_tables, count.index)
  destination_cidr_block    = var.acceptor_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}

resource "aws_route" "acceptor_to_requester" {
  provider                  = aws.acceptor
  count                     = var.acceptor_vpc_route_tables_count
  route_table_id            = element(var.acceptor_vpc_route_tables, count.index)
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}

