# Create Private Hosted Zone
resource "aws_route53_zone" "private" {
  lifecycle {
    # Ignore changes to VPC associations
    ignore_changes = [vpc]
  }

  name = var.phz_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name      = "${var.phz_name}-phz${var.name_suffix}"
    Terraform = "true"
  }
}

# Create Public Hosted Zone
resource "aws_route53_zone" "public" {
  name = var.hz_name

  tags = {
    Name      = "${var.hz_name}-hz${var.name_suffix}"
    Terraform = "true"
  }
}

# UPSERT statement
resource "template_file" "ds" {
  template = <<EOF
{ "Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "$${zone_name}", "ResourceRecords": [ { "Value": "$${ns_0}" }, { "Value": "$${ns_1}" }, { "Value": "$${ns_2}" }, { "Value": "$${ns_3}" } ], "TTL": 30, "Type": "NS" } } ] }
EOF


  vars = {
    zone_name = aws_route53_zone.public.name
    ns_0      = aws_route53_zone.public.name_servers[0]
    ns_1      = aws_route53_zone.public.name_servers[1]
    ns_2      = aws_route53_zone.public.name_servers[2]
    ns_3      = aws_route53_zone.public.name_servers[3]
  }

  provisioner "local-exec" {
    command = <<EOF
aws route53 change-resource-record-sets --hosted-zone-id ${var.main_zone_id} --change-batch ${jsonencode(replace(template_file.ds.rendered, "\n", ""))} --profile ${var.main_zone_profile}
EOF

  }
}

# Add HZ deligation set to main Zone
/*
Unless we use a specific TF user to run out config we
cannot setup or expect the user perms to be able to
write to a zone file in a different account.

resource "aws_route53_record" "ds" {
    zone_id = "${var.main_zone_id}"
    name = "${var.hz_name}"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.public.name_servers.0}",
        "${aws_route53_zone.public.name_servers.1}",
        "${aws_route53_zone.public.name_servers.2}",
        "${aws_route53_zone.public.name_servers.3}"
    ]
}*/

# DHCP Option set and association
resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name = "${var.subdomain_name}.${var.domain_name}"

  domain_name_servers = [
    cidrhost(element(var.private_subnets_cidrs, 0), 4),
    cidrhost(element(var.private_subnets_cidrs, 1), 4),
    "8.8.8.8",
    "8.8.4.4",
  ]

  tags = merge(
    var.tags,
    {
      "Name" = "dhcp-dos${var.name_suffix}"
    },
  )
}

resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

# test dns records
resource "aws_route53_record" "test_hz" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "test"
  type    = "TXT"
  ttl     = "86400"
  records = ["pub"]
}

resource "aws_route53_record" "test_phz" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "test"
  type    = "TXT"
  ttl     = "86400"
  records = ["priv"]
}

/* Route53 fowarders */
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "inbound-res${var.name_suffix}"
  direction = "INBOUND"

  security_group_ids = [
    var.sg_dns_id,
  ]

  ip_address {
    subnet_id = element(var.private_subnets, 0)
    ip        = cidrhost(element(var.private_subnets_cidrs, 0), 4)
  }

  ip_address {
    subnet_id = element(var.private_subnets, 1)
    ip        = cidrhost(element(var.private_subnets_cidrs, 1), 4)
  }

  ip_address {
    subnet_id = element(var.private_subnets, 2)
    ip        = cidrhost(element(var.private_subnets_cidrs, 2), 4)
  }

  tags = {
    Environment = var.default_tags["Environment"]
    Owner       = var.default_tags["Owner"]
    Project     = var.default_tags["Project"]
    Terraform   = var.default_tags["Terraform"]
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "outbound-res${var.name_suffix}"
  direction = "OUTBOUND"

  security_group_ids = [
    var.sg_dns_id,
  ]

  ip_address {
    subnet_id = element(var.private_subnets, 0)
    ip        = cidrhost(element(var.private_subnets_cidrs, 0), 5)
  }

  ip_address {
    subnet_id = element(var.private_subnets, 1)
    ip        = cidrhost(element(var.private_subnets_cidrs, 1), 5)
  }

  ip_address {
    subnet_id = element(var.private_subnets, 2)
    ip        = cidrhost(element(var.private_subnets_cidrs, 2), 5)
  }

  tags = {
    Environment = var.default_tags["Environment"]
    Owner       = var.default_tags["Owner"]
    Project     = var.default_tags["Project"]
    Terraform   = var.default_tags["Terraform"]
  }
}

# would be nice to have 0.12 for..each but locals will have to do for now
locals {
  outbound_forward_domains = var.outbound_forward_domains
}

resource "aws_route53_resolver_rule" "outbound" {
  name = replace(
    element(local.outbound_forward_domains, count.index),
    ".",
    "_",
  )
  domain_name          = element(local.outbound_forward_domains, count.index)
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  target_ip {
    # return IP address without CIDR mask
    ip = var.target_ip_1
  }

  target_ip {
    ip = var.target_ip_2
  }

  tags = {
    Environment = var.default_tags["Environment"]
    Owner       = var.default_tags["Owner"]
    Project     = var.default_tags["Project"]
    Terraform   = var.default_tags["Terraform"]
  }

  count = length(local.outbound_forward_domains)
}

resource "aws_route53_resolver_rule_association" "outbound" {
  name = replace(
    element(local.outbound_forward_domains, count.index),
    ".",
    "_",
  )
  resolver_rule_id = element(aws_route53_resolver_rule.outbound.*.id, count.index)
  vpc_id           = var.vpc_id

  count = length(local.outbound_forward_domains)
}
