# Module: VPC Peering
AWS VPC peering module for connecting 2 separate VPCs.

## Requirements
* None

## Usage
```
module "vpc-peering" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/vpc-peering/?ref=master"
  ...
}
```

## Pre-Requisites
### Warning
You must be signed in to both the "acceptor" and "requester" accounts in order to use this module.

resource "aws_vpc_peering_connection" "requester" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_owner_id = var.acceptor_account_id
  peer_vpc_id   = var.acceptor_vpc_id
  peer_region   = var.acceptor_aws_region
  auto_accept   = false
  tags          = var.tags
}

As the peering is set up in the acceptor account with the acceptor as the owner, but the terraform is run from the requestor account;
failure to have valid 'onelogin' aws credentials for both accounts will cause your terraform plan to hang and eventually give a credential error.

## Parameters
### Required
* acceptor_account_id (str): Acceptor VPC AWS account ID
* acceptor_aws_profile (str): Acceptor VPC AWS profile to connect with
* acceptor_aws_region (str): Acceptor VPC AWS region
* acceptor_vpc_cidr (str): Acceptor VPC CIDR block
* acceptor_vpc_id (str): Acceptor VPC ID
* acceptor_vpc_route_tables (list): Acceptor VPC route tables to update
* acceptor_vpc_route_tables_count (int): Accpetor VPC route table count
* requester_account_id (str): Requestor VPC AWS account ID
* requester_aws_profile (str): Requestor VPC AWS profile to connect with
* requester_aws_region (str): Requestor VPC AWS region
* requester_vpc_cidr (str): Requestor VPC CIDR block
* requester_vpc_id (str): Requestor VPC ID
* requester_vpc_route_tables (str): Requestor VPC route tables to update
* requester_vpc_route_tables_count (int): Requestor VPC route table count
* tags (map): Tags to apply to all taggable resources

### Optional
* None