module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "17.19.0"

  cluster_name = var.cluster_name
  cluster_version = "1.18"

  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_irsa = true
  write_kubeconfig = true

  worker_groups = [
    {
      name = "wg-main"
      instance_type = "m5.xlarge"
      additional_userdata = "echo foo bar"
      asg_desired_capacity = 1
      asg_max_size = 5
      # autoscaling is enabled
      additional_security_group_ids = [
        aws_security_group.eks.id]
      tags = [
        {
          key = "k8s.io/cluster-autoscaler/enabled"
          propagate_at_launch = "false"
          value = "true"
        },
        {
          key = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          propagate_at_launch = "false"
          value = "true"
        }
      ]
    },
    {
      name                = "wg-spot-1"
      spot_price          = "0.2"
      instance_type       = "m5.xlarge"
      asg_max_size        = 10
      kubelet_extra_args  = "--node-labels=node.kubernetes.io/lifecycle=spot"
      suspended_processes = ["AZRebalance"]
      tags = [
        {
          key = "k8s.io/cluster-autoscaler/enabled"
          propagate_at_launch = "false"
          value = "true"
        },
        {
          key = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          propagate_at_launch = "false"
          value = "true"
        }
      ]
    },
  ]
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}