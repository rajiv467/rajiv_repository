variable "name" {
  description = "Repository name"
}

variable "admin_mgmt_role_arn" {
  description = "ARN of the role to allow Admin of the repo"
}

variable "ecs_cluster_role_arn" {
  description = "ARNs of the ECS cluster roles"
  type        = list(string)
}

