output "phz_zone_id" {
  value = aws_route53_zone.private.zone_id
}

output "phz_ns" {
  value = aws_route53_zone.private.name_servers
}

output "hz_zone_id" {
  value = aws_route53_zone.public.zone_id
}

output "hz_ns" {
  value = aws_route53_zone.public.name_servers
}

output "r53_endpoint_outbound_id" {
  value = aws_route53_resolver_endpoint.outbound.id
}

