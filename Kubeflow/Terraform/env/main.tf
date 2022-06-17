provider "aws" {
  region = var.region
}

module "kubeflow" {
  source = "../../modules/kubeflow"
  cluster_name = var.cluster_name
  region = var.region
  vpc_name = var.vpc_name
}

