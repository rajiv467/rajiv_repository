/* Add common Security Groups */
module "sg_common" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/sg_common/"

  name_suffix                       = var.name_suffix
  cidrs                             = var.cidrs
  vpc_id                            = var.vpc_id
  vpc_cidr                          = var.vpc_cidr
  additional_vpc_ipv4_cidr_blocks   = var.additional_vpc_ipv4_cidr_blocks
  default_tags                      = var.default_tags
}

/* Instance profile for the ec2bootstrap role */
resource "aws_iam_instance_profile" "ec2bootstrap" {
  name = "ec2bootstrap-pro${var.name_suffix}"
  role = aws_iam_role.ec2bootstrap.name
}

/* EC2 role to allow bootstrap */
resource "aws_iam_role" "ec2bootstrap" {
  name               = "ec2bootstrap-role${var.name_suffix}"
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
}

resource "aws_iam_role_policy" "ec2bootstrap" {
  name   = "ec2bootstrap-pol${var.name_suffix}"
  role   = aws_iam_role.ec2bootstrap.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${var.ansiblesrc_s3_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${var.ansiblesrc_s3_arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*Address",
                "ec2:*Addresses",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

/* onelogin idp */
resource "aws_iam_saml_provider" "idp" {
  name                   = "onelogin-idp${var.name_suffix}"
  saml_metadata_document = var.saml_metadata
}

/* Add a TF EC2 key */
resource "aws_key_pair" "tf" {
  key_name   = "tf-key${var.name_suffix}"
  public_key = var.tf_key_pub
}
