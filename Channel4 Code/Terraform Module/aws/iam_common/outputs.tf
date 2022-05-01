output "c4_admin_role_arn" {
  value = aws_iam_role.c4_admin.arn
}

output "c4_admin_role_name" {
  value = aws_iam_role.c4_admin.name
}

output "c4_power_role_arn" {
  value = aws_iam_role.c4_power.arn
}

output "c4_power_role_name" {
  value = aws_iam_role.c4_power.name
}

output "c4_support_role_arn" {
  value = aws_iam_role.c4_support.arn
}

output "c4_support_role_name" {
  value = aws_iam_role.c4_support.name
}

output "c4_billing_role_arn" {
  value = aws_iam_role.c4_billing.arn
}

output "c4_billing_role_name" {
  value = aws_iam_role.c4_billing.name
}

output "onelogin_role_trust" {
  value = data.template_file.saml_trust.rendered
}

output "tfcigovernanceaudit_role" {
  value = {
    "role_name" = aws_iam_role.terraform_ci_governance_audit.name
    "role_arn"  = aws_iam_role.terraform_ci_governance_audit.arn
  }
}

