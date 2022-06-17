//output "ssh_private_key" {
//  value = module.notebook-vm.ssh_private_key
//}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = var.cluster_name
}

output "cluster_role_name" {
  description = "Name of the role that kubeflow will use to control the cluster."
  value = module.kubeflow.cluster_role_name
}

output "cluster_autoscale_role_name" {
  description = "Name of the role that EKS uses to autoscale"
  value = module.kubeflow.cluster_autoscale_role_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value = module.kubeflow.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value = module.kubeflow.cluster_security_group_id
}

output "aws_account_id" {
  value = module.kubeflow.aws_account_id
}