variable "mstwarn_topics_ew1" {
  type        = list(string)
  description = "MST WARN SNS topic arns"
}

variable "mstcrit_topics_ew1" {
  type        = list(string)
  description = "MST CRIT SNS topic arns"
}

variable "mstwarnprod_topics_ew1" {
  type        = list(string)
  description = "MST PROD WARN SNS topic arns"
}

variable "mstcritprod_topics_ew1" {
  type        = list(string)
  description = "MST PROD CRIT SNS topic arns"
}

variable "external_alerts_sns_endpoint" {
  description = "External Alerts API GW SNS Endpoint"
}

