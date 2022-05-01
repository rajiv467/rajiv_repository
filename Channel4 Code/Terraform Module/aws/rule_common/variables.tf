variable "name_suffix" {
  description = "Object name suffix"
}

variable "profile" {
  description = "Profile to use with local-exec commands"
}

variable "cloudtrail_s3_id" {
  description = "S3 Id for CloudTrail bucket"
}

variable "lambda_s3_id" {
  description = "S3 bucket for Lambda functions"
}

variable "account_id" {
  description = "AWS account id"
}

variable "usermfaenabled" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule usermfaenabled"
}

variable "serviceuserconsoledisabled" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule serviceuserconsoledisabled"
}

variable "powerfulactionsallowed" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule powerfulactionsallowed"
}

variable "usercredsnotused" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule usercredsnotused"
}

variable "flowlogsenabled" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule flowlogsenabled"
}

variable "restrictports" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule restrictports"
}

variable "instancesinvpc" {
  type        = map(string)
  description = "Lambda handler for Custom Config Rule instancesinvpc"
}

variable "mstcrit_topic_arn" {
  description = "MSTCrit SNS topic ARN"
}

variable "mstwarn_topic_arn" {
  description = "MSTWarn SNS topic ARN"
}

variable "dst_s3_id" {
  description = "S3 bucket for Lambda functions"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

