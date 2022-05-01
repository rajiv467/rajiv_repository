# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_azs" {
  value = module.vpc.private_subnets_azs
}

output "private_subnets_cidrs" {
  value = module.vpc.private_subnets_cidrs
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnets_azs" {
  value = module.vpc.public_subnets_azs
}

output "public_subnets_cidrs" {
  value = module.vpc.public_subnets_cidrs
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "flow_log_id" {
  value = module.vpc.flow_log_id
}

output "flow_log_group_name" {
  value = module.vpc.flow_log_group_name
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_gateway_public_ips
}

output "s3_endpoint_id" {
  value = module.vpc.s3_endpoint_id
}

output "public_nacl_id" {
  value = module.vpc.public_nacl_id
}

output "private_nacl_id" {
  value = module.vpc.private_nacl_id
}
