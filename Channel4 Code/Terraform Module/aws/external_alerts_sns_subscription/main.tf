locals {
  # SNS topic arns from ew1 to be subscribed to External Alerts API GW SNS Endpoint
  mstwarn_topics_ew1 = var.mstwarn_topics_ew1

  # SNS topic arns from ew1 to be subscribed External Alerts API GW SNS Endpoint
  mstcrit_topics_ew1 = var.mstcrit_topics_ew1

  # PROD SNS topic arns from ew1 to be subscribed to External Alerts API GW SNS Endpoint
  mstwarnprod_topics_ew1 = var.mstwarnprod_topics_ew1

  # PROD SNS topic arns from ew1 to be subscribed to External Alerts API GW SNS Endpoint
  mstcritprod_topics_ew1 = var.mstcritprod_topics_ew1
}

resource "aws_sns_topic_subscription" "governance_notification_mstwarn_ew1" {
  topic_arn              = element(local.mstwarn_topics_ew1, count.index)
  protocol               = "https"
  endpoint               = var.external_alerts_sns_endpoint
  endpoint_auto_confirms = true

  count = length(local.mstwarn_topics_ew1)
}

resource "aws_sns_topic_subscription" "governance_notification_mstcrit_ew1" {
  topic_arn              = element(local.mstcrit_topics_ew1, count.index)
  protocol               = "https"
  endpoint               = var.external_alerts_sns_endpoint
  endpoint_auto_confirms = true

  count = length(local.mstcrit_topics_ew1)
}

resource "aws_sns_topic_subscription" "governance_notification_mstwarnprod_ew1" {
  topic_arn              = element(local.mstwarnprod_topics_ew1, count.index)
  protocol               = "https"
  endpoint               = var.external_alerts_sns_endpoint
  endpoint_auto_confirms = true

  count = length(local.mstwarnprod_topics_ew1)
}

resource "aws_sns_topic_subscription" "governance_notification_mstcritprod_ew1" {
  topic_arn              = element(local.mstcritprod_topics_ew1, count.index)
  protocol               = "https"
  endpoint               = var.external_alerts_sns_endpoint
  endpoint_auto_confirms = true

  count = length(local.mstcritprod_topics_ew1)
}

