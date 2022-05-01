/* VPC, Subnets, Internet Gateway, Route tables
adapted from https://github.com/terraform-community-modules/tf_aws_vpc
*/

resource "aws_vpc" "mod" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}-vpc${var.name_suffix}"
    },
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "mod" {
  vpc_id      = aws_vpc.mod.id
  cidr_block  = element(var.additional_vpc_ipv4_cidr_blocks, count.index)

  count = length(var.additional_vpc_ipv4_cidr_blocks)
}

resource "aws_internet_gateway" "mod" {
  vpc_id = aws_vpc.mod.id

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}-igw${var.name_suffix}"
    },
  )
}

resource "aws_eip" "nat" {
  vpc = true

  #network_interface = "${element(aws_network_interface.nat.*.id, count.index)}"

  count = length(compact(split(",", var.public_subnets)))
}

resource "aws_nat_gateway" "mod" {
  depends_on = [aws_internet_gateway.mod]

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  count = length(compact(split(",", var.public_subnets)))
}

resource "aws_route_table" "public" {
  vpc_id           = aws_vpc.mod.id
  propagating_vgws = var.propagte_vgws

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}pub-rt${var.name_suffix}"
    },
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mod.id
}

resource "aws_route_table" "private" {
  vpc_id           = aws_vpc.mod.id
  propagating_vgws = var.propagte_vgws

  count = length(compact(split(",", var.private_subnets)))

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}priv-rt${var.name_suffix}"
    },
  )
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.mod.*.id, count.index)

  count = length(compact(split(",", var.public_subnets)))
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.mod.id
  cidr_block              = element(split(",", var.private_subnets), count.index)
  availability_zone       = "${var.region}${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = var.private_subnet_map_public_ip

  count = length(compact(split(",", var.private_subnets)))

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}-priv${var.name_suffix}"
    },
    {
      "kubernetes.io/cluster/EKS-POC" = "shared"
    },
    {
      "kubernetes.io/role/internal-elb" = "1"
    },
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.mod.id
  cidr_block              = element(split(",", var.public_subnets), count.index)
  availability_zone       = "${var.region}${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = var.public_subnet_map_public_ip

  count = length(compact(split(",", var.public_subnets)))

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}-pub${var.name_suffix}"
    },
  )
}

resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

  count = length(compact(split(",", var.private_subnets)))
}

resource "aws_vpc_endpoint_route_table_association" "private" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
  route_table_id  = element(aws_route_table.private.*.id, count.index)

  count = var.private_vpce_s3_route ? length(compact(split(",", var.private_subnets))) : 0
}

resource "aws_route_table_association" "public" {
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id

  count = length(compact(split(",", var.public_subnets)))
}

resource "aws_vpc_endpoint_route_table_association" "public" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
  route_table_id  = aws_route_table.public.id

  count = var.public_vpce_s3_route ? 1 : 0
}

/* S3 endpoint
Route table associations with aws_route_table defintiions
*/

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.mod.id
  service_name = "com.amazonaws.eu-west-1.s3"
  policy       = var.vpce_s3_policy
  #route_table_ids = ["${aws_route_table.public.id}", "${aws_route_table.private.*.id}"]
}

/* NACLs
Rules to be added to a seperate module https://github.com/hashicorp/terraform/issues/2459
*/
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.mod.id
  subnet_ids = split(",", join(",", aws_subnet.public.*.id))

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}pub-nacl${var.name_suffix}"
    },
  )
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.mod.id
  subnet_ids = split(",", join(",", aws_subnet.private.*.id))

  tags = merge(
    var.default_tags,
    {
      "Name" = "${var.name}priv-nacl${var.name_suffix}"
    },
  )
}

/* Flow log
*/

resource "aws_flow_log" "flow_log" {
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  iam_role_arn    = aws_iam_role.flow_log.arn
  vpc_id          = aws_vpc.mod.id
  traffic_type    = var.flow_log_type
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "${var.name}-lg${var.name_suffix}"
  retention_in_days = var.flow_log_retention
}

resource "aws_iam_role" "flow_log" {
  name = "${var.name}-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "flow_log" {
  name = "${var.name}-pol${var.name_suffix}"
  role = aws_iam_role.flow_log.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

