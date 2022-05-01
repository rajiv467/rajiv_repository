output "vpc_id" {
  value = aws_vpc.mod.id
}

output "vpc_cidr" {
  value = aws_vpc.mod.cidr_block
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "private_subnets_azs" {
  value = aws_subnet.private.*.availability_zone
}

output "private_subnets_cidrs" {
  value = aws_subnet.private.*.cidr_block
}

output "private_route_table_ids" {
  value = aws_route_table.private.*.id
}

output "private_nacl_id" {
  value = aws_network_acl.private.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "public_subnets_azs" {
  value = aws_subnet.public.*.availability_zone
}

output "public_subnets_cidrs" {
  value = aws_subnet.public.*.cidr_block
}

output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}

output "public_nacl_id" {
  value = aws_network_acl.public.id
}

output "flow_log_id" {
  value = aws_flow_log.flow_log.id
}

output "flow_log_group_name" {
  value = aws_cloudwatch_log_group.flow_log.name
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.mod.*.id
}

output "nat_gateway_public_ips" {
  value = aws_nat_gateway.mod.*.public_ip
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3_endpoint.id
}
