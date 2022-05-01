output "nacl_rule_ids" {
  value = join(",", aws_network_acl_rule.rule.*.id)
}

