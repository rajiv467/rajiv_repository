variable "project" {
  default     = ""
  description = "Project name"
}

variable "cluster_name" {
  default     = ""
  description = "Cluster name"
}

variable "min_capacity" {
  default     = 1
  description = "Minimum capacity"
}

variable "max_capacity" {
  default     = 10
  description = "Maximum capacity"
}

variable "ecs_service_name" {
  default     = ""
  description = "ECS service name"
}

variable "scale_up_threshold" {
  default     = 80
  description = "Scale-up threshold"
}

variable "scale_down_threshold" {
  default     = 10
  description = "Scale down threshold"
}

