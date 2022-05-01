output "sg_ssh_id" {
  value = aws_security_group.ssh.id
}

output "sg_ssh_jump_id" {
  value = aws_security_group.ssh_jump.id
}

output "sg_rdp_id" {
  value = aws_security_group.rdp.id
}

output "sg_monitoring_id" {
  value = aws_security_group.monitoring.id
}

output "sg_http_id" {
  value = aws_security_group.http.id
}

output "sg_http_elb_id" {
  value = aws_security_group.http_elb.id
}

output "sg_dns_id" {
  value = aws_security_group.dns.id
}

output "sg_ntp_id" {
  value = aws_security_group.ntp.id
}

output "sg_egress_id" {
  value = aws_security_group.egress.id
}

