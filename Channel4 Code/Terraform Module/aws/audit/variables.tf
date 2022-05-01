variable "name_suffix" {
  description = "Object name suffix"
}

/*
variable "mst_sqs_profile" {
    description = "Local profile to use to subscribe SNS topics"
}
*/
variable "mst_sqs_account_id" {
  description = "AWS account id for account containing MST SQS queues"
}

variable "mstwarn_sqs_arn" {
  description = "SQS ARN for the MST Warn queue"
}

variable "mstwarn_sqs_url" {
  description = "SQS URL for the MST Warn queue"
}

variable "mstcrit_sqs_arn" {
  description = "SQS ARN for the MST Crit queue"
}

variable "mstcrit_sqs_url" {
  description = "SQS URL for the MST Crit queue"
}

variable "mstwarnprod_sqs_arn" {
  description = "SQS ARN for the MST Warn queue"
}

variable "mstwarnprod_sqs_url" {
  description = "SQS URL for the MST Warn queue"
}

variable "mstcritprod_sqs_arn" {
  description = "SQS ARN for the MST Crit queue"
}

variable "mstcritprod_sqs_url" {
  description = "SQS URL for the MST Crit queue"
}

variable "vpc_cidr_b" {
  description = "B class of VPC CIDR block used for pattern matching"
}

variable "flow_log_group_name" {
  description = "VPC Flow log group name"
}

variable "lambda_s3_id" {
  description = "S3 bucket for Lambda functions"
}

variable "vpcmetrics" {
  type        = map(string)
  description = "Lambda facts for function vpc-metrics"
}

variable "vpc_id" {
  description = "VPC Id to pass via CW rule to VPC Metric lambda function"
}

variable "subnet_ids" {
  description = "Comma delimetered list of subnet ids to pass via CW rule to VPC Metric lambda function"
}

variable "sg_count_limit" {
  description = "CW Alarm threshold. SG Count (default: 400)"
  default     = 400
}

variable "elb_count_limit" {
  description = "CW Alarm threshold. ELB Count (default: 15)"
  default     = 15
}

variable "availip_count_limit" {
  description = "CW Alarm threshold. Subnet available IPs (default: 20)"
  default     = 20
}

variable "flow_rejected_outbound_limit" {
  description = "CW Alarm threshold. Flow log num rejected outbound in 5min period (default: 100)"
  default     = 200
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

variable "account_id" {
  description = "AWS account id"
}

/* External Alerts */
variable "external_alerts_sns_endpoint" {
  description = "External Alerts API GW SNS Endpoint"
}

