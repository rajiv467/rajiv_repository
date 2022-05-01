variable "name" {
  description = "Collector name"
  type        = string
}

variable "collection_endpoint" {
  description = "Sumo collection endpoint"
  type        = string
}

variable "cfn_update_email" {
  description = "Email for Cfn update alerts"
  type        = string
  default     = "Channel4-Capability@piksel.com"
}

variable "workers" {
  description = "Number of workers"
  type        = number
  default     = 4
}

variable "log_format" {
  description = "Log format: [VPC-RAW|VPC-JSON|Others]"
  type        = string
  default     = "Others"
}

variable "loggroup_info" {
  description = "Include Log Group / Stream info in logs [true|false]"
  type        = bool
  default     = false
}

variable "sumo_cwlogs_lambda_name" {
  description = "Sumo CWLogs lambda fn name"
  type        = string
}

variable "sumo_dlq_lambda_name" {
  description = "Sumo DLQ processor fn name"
  type        = string
}