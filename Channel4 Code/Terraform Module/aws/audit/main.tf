/* Enable and configure *VPC* level audit services */

/* Setup the SNS topics to push to MST WARN and CRIT queues used to integrate with Nagios and POM
https://wiki.piksel.com/display/asgc4/SQS+driven+Nagios+alerts#?lucidIFH-viewer-6f4fbcdb=1
SQS queues setup in global (must exist in nmadmin prior to VPC stack)*/
resource "aws_sns_topic" "mstwarn_topic" {
  name = "mstwarn-sns${var.name_suffix}"
}

# policy
resource "aws_sns_topic_policy" "mstwarn_topic" {
  arn = aws_sns_topic.mstwarn_topic.arn

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "__default_policy_ID",
    "Statement": [
        {
            "Sid": "__default_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SNS:GetTopicAttributes",
                "SNS:SetTopicAttributes",
                "SNS:AddPermission",
                "SNS:RemovePermission",
                "SNS:DeleteTopic",
                "SNS:Subscribe",
                "SNS:ListSubscriptionsByTopic",
                "SNS:Publish",
                "SNS:Receive"
            ],
            "Resource": "${aws_sns_topic.mstwarn_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceOwner": "${var.account_id}"
                }
            }
        },
        {
            "Sid": "Allow_CWEvents_Publish",
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "SNS:Publish",
            "Resource": "${aws_sns_topic.mstwarn_topic.arn}"
        },
        {
            "Sid": "Allow_nmadmin_Subscribe",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:Subscribe",
            "Resource": "${aws_sns_topic.mstwarn_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "SNS:Endpoint": [
                        "${var.external_alerts_sns_endpoint}"
                    ]
                }
            }
        },
        {
            "Sid": "Allow_nmadmin_ListSubscriptionsByTopic",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:ListSubscriptionsByTopic",
            "Resource": "${aws_sns_topic.mstwarn_topic.arn}"
        }
    ]
}
EOF

}

resource "aws_sns_topic" "mstcrit_topic" {
  name = "mstcrit-sns${var.name_suffix}"
}

# policy
resource "aws_sns_topic_policy" "mstcrit_topic" {
  arn = aws_sns_topic.mstcrit_topic.arn

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "__default_policy_ID",
    "Statement": [
        {
            "Sid": "__default_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SNS:GetTopicAttributes",
                "SNS:SetTopicAttributes",
                "SNS:AddPermission",
                "SNS:RemovePermission",
                "SNS:DeleteTopic",
                "SNS:Subscribe",
                "SNS:ListSubscriptionsByTopic",
                "SNS:Publish",
                "SNS:Receive"
            ],
            "Resource": "${aws_sns_topic.mstcrit_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceOwner": "${var.account_id}"
                }
            }
        },
        {
            "Sid": "Allow_CWEvents_Publish",
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "SNS:Publish",
            "Resource": "${aws_sns_topic.mstcrit_topic.arn}"
        },
        {
            "Sid": "Allow_nmadmin_Subscribe",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:Subscribe",
            "Resource": "${aws_sns_topic.mstcrit_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "SNS:Endpoint": [
                        "${var.external_alerts_sns_endpoint}"
                    ]
                }
            }
        },
        {
            "Sid": "Allow_nmadmin_ListSubscriptionsByTopic",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:ListSubscriptionsByTopic",
            "Resource": "${aws_sns_topic.mstcrit_topic.arn}"
        }
    ]
}
EOF

}

resource "aws_sns_topic" "mstwarnprod_topic" {
  name = "mstwarnprod-sns${var.name_suffix}"
}

# policy
resource "aws_sns_topic_policy" "mstwarnprod_topic" {
  arn = aws_sns_topic.mstwarnprod_topic.arn

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "__default_policy_ID",
    "Statement": [
        {
            "Sid": "__default_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SNS:GetTopicAttributes",
                "SNS:SetTopicAttributes",
                "SNS:AddPermission",
                "SNS:RemovePermission",
                "SNS:DeleteTopic",
                "SNS:Subscribe",
                "SNS:ListSubscriptionsByTopic",
                "SNS:Publish",
                "SNS:Receive"
            ],
            "Resource": "${aws_sns_topic.mstwarnprod_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceOwner": "${var.account_id}"
                }
            }
        },
        {
            "Sid": "Allow_CWEvents_Publish",
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "SNS:Publish",
            "Resource": "${aws_sns_topic.mstwarnprod_topic.arn}"
        },
        {
            "Sid": "Allow_nmadmin_Subscribe",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:Subscribe",
            "Resource": "${aws_sns_topic.mstwarnprod_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "SNS:Endpoint": [
                        "${var.external_alerts_sns_endpoint}"
                    ]
                }
            }
        },
        {
            "Sid": "Allow_nmadmin_ListSubscriptionsByTopic",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:ListSubscriptionsByTopic",
            "Resource": "${aws_sns_topic.mstwarnprod_topic.arn}"
        }
    ]
}
EOF

}

resource "aws_sns_topic" "mstcritprod_topic" {
  name = "mstcritprod-sns${var.name_suffix}"
}

# policy
resource "aws_sns_topic_policy" "mstcritprod_topic" {
  arn = aws_sns_topic.mstcritprod_topic.arn

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "__default_policy_ID",
    "Statement": [
        {
            "Sid": "__default_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SNS:GetTopicAttributes",
                "SNS:SetTopicAttributes",
                "SNS:AddPermission",
                "SNS:RemovePermission",
                "SNS:DeleteTopic",
                "SNS:Subscribe",
                "SNS:ListSubscriptionsByTopic",
                "SNS:Publish",
                "SNS:Receive"
            ],
            "Resource": "${aws_sns_topic.mstcritprod_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceOwner": "${var.account_id}"
                }
            }
        },
        {
            "Sid": "Allow_CWEvents_Publish",
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "SNS:Publish",
            "Resource": "${aws_sns_topic.mstcritprod_topic.arn}"
        },
        {
            "Sid": "Allow_nmadmin_Subscribe",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:Subscribe",
            "Resource": "${aws_sns_topic.mstcritprod_topic.arn}",
            "Condition": {
                "StringEquals": {
                    "SNS:Endpoint": [
                        "${var.external_alerts_sns_endpoint}"
                    ]
                }
            }
        },
        {
            "Sid": "Allow_nmadmin_ListSubscriptionsByTopic",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.mst_sqs_account_id}:root"
            },
            "Action": "SNS:ListSubscriptionsByTopic",
            "Resource": "${aws_sns_topic.mstcritprod_topic.arn}"
        }
    ]
}
EOF

}

/* Common CW Log metric from VPC Flow logs
https://wiki.piksel.com/display/asgc4/AWSFW+VPC#?lucidIFH-viewer-9ffbb58b=1 */
resource "aws_cloudwatch_log_metric_filter" "flow_rejected_inbound" {
  name           = "flowrejectedinbound-mf${var.name_suffix}"
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr = ${var.vpc_cidr_b}, srcport, dstport, protocol, packets, bytes, start, end, action = REJECT, log_status]"
  log_group_name = var.flow_log_group_name

  metric_transformation {
    name      = "RejectedInbound"
    namespace = "FlowLog"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "flow_rejected_outbound" {
  name           = "flowrejectedoutbound-mf${var.name_suffix}"
  pattern        = "[version, account_id, interface_id, srcaddr = ${var.vpc_cidr_b}, dstaddr, srcport != 0, dstport, protocol, packets, bytes, start, end, action = REJECT, log_status]"
  log_group_name = var.flow_log_group_name

  metric_transformation {
    name      = "RejectedOutbound"
    namespace = "FlowLog"
    value     = "1"
  }
}

/* create an alarm for outbound */
resource "aws_cloudwatch_metric_alarm" "flow_rejected_outbound" {
  alarm_name          = "flowrejectedoutbound-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RejectedOutbound"
  namespace           = "FlowLog"
  period              = "300" # 5m
  statistic           = "Sum"
  threshold           = var.flow_rejected_outbound_limit

  # no data to check yet
  #dimensions { }
  alarm_description = "FlowLog.RejectedOutbound >= ${var.flow_rejected_outbound_limit} for 5min"

  alarm_actions = [aws_sns_topic.mstwarn_topic.arn]
}

/* VPC Metrics */

# create function
module "lambda_vpcmetrics" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.vpcmetrics["name"]
  description = var.vpcmetrics["description"]

  src_hash = var.vpcmetrics["src_hash"]

  dst_s3_id  = var.lambda_s3_id
  dst_s3_key = var.vpcmetrics["dst_s3_key"]

  runtime = var.vpcmetrics["runtime"]
  memory  = var.vpcmetrics["memory"]
  timeout = var.vpcmetrics["timeout"]
  policy  = var.vpcmetrics["policy"]
  handler = var.vpcmetrics["handler"]

  is_crit           = var.vpcmetrics["is_crit"]
  mstwarn_topic_arn = aws_sns_topic.mstwarn_topic.arn
  mstcrit_topic_arn = aws_sns_topic.mstcrit_topic.arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
      alert_on_error = "${lookup(var.vpcmetrics, "alert_on_error")}"
      alert_on_duration = "${lookup(var.vpcmetrics, "alert_on_duration")}"
      alert_on_throttle = "${lookup(var.vpcmetrics, "alert_on_throttle")}"
      */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.vpcmetrics["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_cloudwatch_event_rule" "lambda_vpcmetrics" {
  name                = "${var.vpcmetrics["name"]}-er${var.name_suffix}"
  description         = "Push VPC metrics every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_vpcmetrics" {
  rule = aws_cloudwatch_event_rule.lambda_vpcmetrics.name
  arn  = module.lambda_vpcmetrics.function_arn

  # replace event obj with constants
  input = <<EOF
{
    "vpc_id" : "${var.vpc_id}",
    "subnet_ids" : "${var.subnet_ids}"
}
EOF

}

resource "aws_lambda_permission" "lambda_vpcmetrics" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_vpcmetrics.function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_vpcmetrics.arn
}

# CW alarm for VPCMetric SGCount
resource "aws_cloudwatch_metric_alarm" "vpc_sgcount" {
  alarm_name          = "sgcount-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SGCount"
  namespace           = "VPCMetrics"
  period              = "300" # 5m
  statistic           = "Sum"
  threshold           = var.sg_count_limit # soft max 500

  dimensions = {
    Source = module.lambda_vpcmetrics.function_name
    VPC    = var.vpc_id
  }

  alarm_description = "VPCMetrics.SGCount >= ${var.sg_count_limit} for 5min"
  alarm_actions     = [aws_sns_topic.mstwarn_topic.arn]
}

/* create an alarm for ELBCount */
resource "aws_cloudwatch_metric_alarm" "vpc_elbcount" {
  alarm_name          = "elbcount-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ELBCount"
  namespace           = "VPCMetrics"
  period              = "300" # 5m
  statistic           = "Sum"
  threshold           = var.elb_count_limit # soft max 20 per region

  dimensions = {
    Source = module.lambda_vpcmetrics.function_name
    VPC    = var.vpc_id
  }

  alarm_description = "VPCMetrics.ELBCount >= ${var.elb_count_limit} for 5min"
  alarm_actions     = [aws_sns_topic.mstwarn_topic.arn]
}

/* create an alarm for Subnet Avail IPs */
resource "aws_cloudwatch_metric_alarm" "availip_elbcount" {
  alarm_name          = "availip-ma${var.name_suffix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "LowestSubnetAvailIps"
  namespace           = "VPCMetrics"
  period              = "300" # 5m
  statistic           = "Sum"
  threshold           = var.availip_count_limit

  dimensions = {
    Source = module.lambda_vpcmetrics.function_name
    VPC    = var.vpc_id
  }

  alarm_description = "VPCMetrics.LowestSubnetAvailIps <= ${var.availip_count_limit} for 5min"
  alarm_actions     = [aws_sns_topic.mstwarn_topic.arn]
}
