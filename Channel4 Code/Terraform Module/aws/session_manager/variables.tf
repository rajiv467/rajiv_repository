
variable "log_retention" {
  description = "CloudWatch Log retention days"
}

variable "session_timeout" {
  description = "Session Manager length timeout"
}

variable "name_suffix" {
  description = "name suffix"
}

variable "environment" {
  description = "environment: stage | prod"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tag map to apply to resources"
}
