variable "name_suffix" {
  description = "Object name suffix"
}

variable "profile" {
  description = "Profile to use with local-exec commands"
}

variable "cloudtrail_s3_id" {
  description = "S3 id of the central CloudTrail bucket"
}

variable "cloudtrail_log_group_retention" {
  description = "CloudTrail Log Group retention in days (default: 30)"
  default     = 30
}

variable "cloudtrail_multi_region" {
  description = "Set up CloudTrail against all regions (default: true)"
  default     = true
}

variable "cloudtrail_global_events" {
  description = "Set up CloudTrail with global events (default: true)"
  default     = true
}

variable "cloudtrail_log_file_validation" {
  description = "Set up CloudTrail with log file validation enabled (default: true)"
  default     = true
}

variable "config_s3_id" {
  description = "S3 id of the central Config service bucket"
}

variable "config_topic_arn" {
  description = "ARN of the central Config service SNS topic"
}

variable "confighealth" {
  type        = map(string)
  description = "Lambda facts for Config Health Checker"
}

variable "config_history_del_hours" {
  description = "Expected config service history delivery frequency (min 6) used for health check."
  default     = 6
}

variable "config_stream_del_hours" {
  description = "Expected config service stream delivery frequency used for health check."
  default     = 2
}

variable "mstcrit_topic_arn" {
  description = "MSTCrit SNS topic ARN"
}

variable "mstwarn_topic_arn" {
  description = "MSTWarn SNS topic ARN"
}

variable "lambda_s3_id" {
  description = "S3 bucket for Lambda functions"
}

variable "account_id" {
  description = "AWS account id"
}

variable "usermfaenabled" {
  type        = map(string)
  description = "Lambda facts for Custom Config Rule usermfaenabled"
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
  description = "Lambda facts for Custom Config Rule flowlogsenabled"
}

variable "restrictports" {
  type        = map(string)
  description = "Lambda facts for Custom Config Rule restrictports"
}

variable "instancesinvpc" {
  type        = map(string)
  description = "Lambda facts for Custom Config Rule instancesinvpc"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

