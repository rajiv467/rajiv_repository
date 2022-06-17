resource "aws_iam_role" "node_instance_role" {
  name = "kubeflow-${var.cluster_name}-nodegroup-n-NodeInstanceRole-1"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
//  assume_role_policy = templatefile("${path.module}/oidc_assume_role_policy.json", {
//    OIDC_ARN = module.eks.cluster_arn,
//    OIDC_URL = replace(module.eks.cluster_oidc_issuer_url, "https://", ""),
//    NAMESPACE = "kube-system",
//    SA_NAME = "aws-node"
//  })

  tags = {
  }
}


//
// cluster autoscaler
//

locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name = "cluster-autoscaler-aws-cluster-autoscaler-chart"
  cluster_autoscale_role_name = "cluster-autoscaler-${var.cluster_name}"
}


// create role for the cluster auto-scaler service account to assume
// https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf
module "iam_assumable_role_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.5.0"
  create_role = true
  number_of_role_policy_arns = 1
  role_name = local.cluster_autoscale_role_name
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [aws_iam_policy.worker_autoscaling.arn]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}


// https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md
resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = aws_iam_policy.worker_autoscaling.arn
  role = module.eks.worker_iam_role_name
}

resource "aws_iam_policy" "worker_autoscaling" {
  name_prefix = "cluster-autoscaler"
  description = "EKS worker node autoscaling policy for cluster ${module.eks.cluster_id}"
  policy = data.aws_iam_policy_document.worker_autoscaling.json
}

data "aws_iam_policy_document" "worker_autoscaling" {

  statement {
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "sts:AssumeRoleWithWebIdentity"
    ]

    resources = [
      "*"]
  }

  statement {
    sid = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = [
      "*"]
  }

  statement {
    sid = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = [
      "*"]

    condition {
      test = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
      //      variable = "autoscaling:ResourceTag/k8s.io/cluster/${var.cluster_name}"
      values = [
        "owned"]
    }

    condition {
      test = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values = [
        "true"]
    }
  }
}

