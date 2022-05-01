variable "name_suffix" {
  description = "Object name suffix"
}

variable "name" {
  description = "Object name"
}

variable "description" {
  description = "Function description"
}

variable "src_hash" {
  description = "Source hash for bundle"
}

variable "dst_s3_id" {
  description = "S3 bucket Id function is uploaded to"
}

variable "dst_s3_key" {
  description = "S3 key for function bundle"
}

variable "runtime" {
  description = "Function runtime"
  default     = "python3.7"
}

variable "memory" {
  description = "Amount of memory to assign to the function in MB"
  default     = 256
}

variable "timeout" {
  description = "Timeout value for function in seconds (max 5min)"
  default     = 10
}

variable "policy" {
  description = "IAM policy the function will assume"
}

variable "handler" {
  description = "Function handler"
}

variable "is_crit" {
  description = "Set to true if we should use MSTCrit queue for alerting"
  default     = false
}

variable "mstwarn_topic_arn" {
  description = "MSTWarn SNS topic ARN"
}

variable "mstcrit_topic_arn" {
  description = "MSTCrit SNS topic ARN"
}

variable "alert_on_error" {
  description = "Set to true if we should alert on Lambda errors"
  default     = true
}

variable "alert_on_duration" {
  description = "Set to true if we should alert if function duration nears timeout"
  default     = true
}

variable "alert_on_throttle" {
  description = "Set to true if we should alert on concurrent execution rate limiting"
  default     = true
}

variable "invocations_per_hour" {
  description = "Set expected max invocations per hour for function"
  default     = 100
}

variable "reserved_concurrent_executions" {
  description = "Set concurrent executions limit (default unlimited)"
  default     = -1
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables to be passed to the function"

  default = {
    foo = "bar"
  }
}

variable "kms_key_arn" {
  description = "Optional KMS key arn to encrypt env_vars"
  default     = ""
}

variable "publish" {
  description = "Publish a version"
  default     = true
}

variable "latest_alias" {
  description = "Name of Alias to acossiate with $LATEST"
  default     = "DEV"
}

variable "layers" {
  description = "Lambda Layers"
  default     = []
}
