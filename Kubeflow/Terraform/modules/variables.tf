variable "cluster_name" {
  type = string
  default = "kubeflow"
}

variable "vpc_name" {
  type = string
  default = "vpc-kubeflow"
}

variable "region" {
  type = string
  default = "eu-west-2"
}