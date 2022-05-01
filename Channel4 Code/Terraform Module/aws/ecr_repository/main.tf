/* Creates an ECR repository and policy and outputs repo and registry info.
Requires registry name, admin role arn and ecs cluster role arn.
*/
resource "aws_ecr_repository" "repository" {
  name = var.name
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repository.name
  policy     = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AdminManagement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.admin_mgmt_role_arn}"
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        },
        {
            "Sid": "ECSRead",
            "Effect": "Allow",
            "Principal": {
                "AWS": ${jsonencode(var.ecs_cluster_role_arn)}
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ]
        }
    ]
}
EOF

}

