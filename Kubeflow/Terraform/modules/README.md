
# Kubeflow on EKS Terraform Module

Provisions a cluster on EKS ready that is ready to run Kubeflow. 
Includes various roles.
This essentially replicates the `eksctl create cluster` command.

The configuration also provisions for a cluster autoscaler deployment.


### Cluster Autoscaler

The cluster autoscaler requires permission to create and terminate EC2 instances. 
This is accomplished by creating a role and allowing a k8s service account to assume the role.
The permissions are defined in a custom policy that is attached to the role.
Additionally, the service account must use OIDC to verify its identity.


## Example

```hcl
module "kubeflow" {
  source = "../../modules/kubeflow"
  cluster_name = "my-kubeflow-cluster"
  region = "eu-west-2"
  vpc_name = "my-vpc-name"
}
```