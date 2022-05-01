variable "name_suffix" {
  description = "Object name suffix"
}

variable "saml_idp_arn" {
  description = "SAML Idp ARN"
}

variable "saml_iss" {
  description = "SAML Issuer to allow conditional federated access"
}

variable "account_id" {
  description = "Account id to build up SAML principle"
}

variable "ansiblesrc_s3_arn" {
  description = "S3 arn used to create EC2 bootstrap access"
}

variable "cloudtrail_s3_id" {
  description = "CloudTrail S3 bucket id, used for IAM policies"
}

variable "config_s3_id" {
  description = "Config S3 bucket id, used for IAM policies"
}

variable "pub_gpg_key" {
  description = "Public GPG key used to encrypt initial user passwords"
}

variable "tfcigovernanceaudit_role_arn" {
  description = "Terraform CI Governance Audit - IAM role to trust"
}

variable "tfcigovernanceaudit_external_id" {
  description = "Terraform CI Governance Audit - IAM role external id"
}

