data "aws_region" "current" {}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.eks.token
}


//// https://registry.terraform.io/providers/hashicorp/helm/latest/docs
//provider "helm" {
//  kubernetes {
//    host     = data.aws_eks_cluster.cluster.endpoint
//    username = "ClusterMaster"
//    password = "MindTheGap"
//
//    client_certificate     = file("~/.kube/client-cert.pem")
//    client_key             = file("~/.kube/client-key.pem")
//    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
//  }
//}
