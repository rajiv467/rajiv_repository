
resource "aws_cloudwatch_log_group" "session_manager" {
  name              = "session-manager-lg${var.name_suffix}"
  retention_in_days = var.log_retention

  tags = merge(
    var.default_tags,
    {
      "Name"        = "session-manager-lg${var.name_suffix}"
      "Project"     = "Session Manager"
      "Owner"       = "gis-channel4@piksel.com"
      "Environment" = "${var.environment}"
      "Terraform"   = "infrastructure-stacks"
    },
  )
}

resource "aws_ssm_document" "session_manager_prefs" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  tags = merge(
    var.default_tags,
    {
      "Name"        = "SSM-SessionManagerRunShell"
      "Project"     = "Session Manager"
      "Owner"       = "gis-channel4@piksel.com"
      "Environment" = var.environment
      "Terraform"   = "infrastructure-stacks"
    },
  )

  content = <<DOC
{
  "schemaVersion": "1.0",
  "description": "Document to hold regional settings for Session Manager",
  "sessionType": "Standard_Stream",
  "inputs": {
    "s3BucketName": "",
    "s3KeyPrefix": "",
    "s3EncryptionEnabled": true,
    "cloudWatchLogGroupName": "session-manager-lg${var.name_suffix}",
    "cloudWatchEncryptionEnabled": false,
    "idleSessionTimeout": "${var.session_timeout}",
    "cloudWatchStreamingEnabled": true,
    "kmsKeyId": "",
    "runAsEnabled": false,
    "runAsDefaultUser": "",
    "shellProfile": {
      "windows": "",
      "linux": ""
    }
  }
}
DOC
}

resource "aws_iam_policy" "session_manager" {
  name = "session_manager-pol${var.name_suffix}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "kms:GenerateDataKey",
            "Resource": "*"
        }
    ]
}
EOF
}
