output "tf_key_name" {
  value = aws_key_pair.tf.key_name
}

output "ec2bootstrap_role_arn" {
  value = aws_iam_role.ec2bootstrap.arn
}

output "ec2bootstrap_profile_name" {
  value = aws_iam_instance_profile.ec2bootstrap.name
}

/* Security Groups */
output "sg_ssh_id" {
  value = module.sg_common.sg_ssh_id
}

output "sg_ssh_jump_id" {
  value = module.sg_common.sg_ssh_jump_id
}

output "sg_rdp_id" {
  value = module.sg_common.sg_rdp_id
}

output "sg_monitoring_id" {
  value = module.sg_common.sg_monitoring_id
}

output "sg_http_id" {
  value = module.sg_common.sg_http_id
}

output "sg_http_elb_id" {
  value = module.sg_common.sg_http_elb_id
}

output "sg_dns_id" {
  value = module.sg_common.sg_dns_id
}

output "sg_ntp_id" {
  value = module.sg_common.sg_ntp_id
}

output "sg_egress_id" {
  value = module.sg_common.sg_egress_id
}

output "saml_idp_arn" {
  value = aws_iam_saml_provider.idp.arn
}
