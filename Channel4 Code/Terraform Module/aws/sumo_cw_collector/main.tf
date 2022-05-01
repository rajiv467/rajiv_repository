data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

variable "region_map" {
  default = {
    us-east-1 = {
      bucketname = "appdevzipfiles-us-east-1"
    }
    us-east-2 = {
      bucketname = "appdevzipfiles-us-east-2"
    }
    us-west-1 = {
      bucketname = "appdevzipfiles-us-west-1"
    }
    us-west-2 = {
      bucketname = "appdevzipfiles-us-west-2"
    }
    ap-south-1 = {
      bucketname = "appdevzipfiles-ap-south-1"
    }
    ap-northeast-2 = {
      bucketname = "appdevzipfiles-ap-northeast-2"
    }
    ap-southeast-1 = {
      bucketname = "appdevzipfiles-ap-southeast-1"
    }
    ap-southeast-2 = {
      bucketname = "appdevzipfiles-ap-southeast-2"
    }
    ap-northeast-1 = {
      bucketname = "appdevzipfiles-ap-northeast-1"
    }
    ca-central-1 = {
      bucketname = "appdevzipfiles-ca-central-1"
    }
    eu-central-1 = {
      bucketname = "appdevzipfiles-eu-central-1"
    }
    eu-west-1 = {
      bucketname = "appdevzipfiles-eu-west-1"
    }
    eu-west-2 = {
      bucketname = "appdevzipfiles-eu-west-2"
    }
    eu-west-3 = {
      bucketname = "appdevzipfiles-eu-west-3"
    }
    eu-north-1 = {
      bucketname = "appdevzipfiles-eu-north-1s"
    }
    sa-east-1 = {
      bucketname = "appdevzipfiles-sa-east-1"
    }
  }
}

resource "aws_cloudwatch_log_group" "sumo_cw_log_group" {
  name = "SumoCWLogGroup"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_subscription_filter" "sumo_cw_log_subscription_filter" {
  destination_arn = aws_lambda_function.sumo_cw_logs_lambda.arn
  filter_pattern = ""
  log_group_name = aws_cloudwatch_log_group.sumo_cw_log_group.name
  name = "SumoCWLogSubscriptionFilter"

  depends_on = [
    aws_cloudwatch_log_group.sumo_cw_log_group,
    aws_lambda_permission.sumo_cw_lambda_permission,
    aws_lambda_function.sumo_cw_logs_lambda]
}

resource "aws_lambda_permission" "sumo_cw_lambda_permission" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sumo_cw_logs_lambda.arn
  principal = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_sqs_queue" "sumo_cw_dead_letter_queue" {
  name = "SumoCWDeadLetterQueue"
}

resource "aws_iam_role" "sumo_cw_lambda_execution_role" {
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          "Service": "lambda.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
  path = "/"
  inline_policy {
    name = "SQSCreateLogsRolePolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "sqs:DeleteMessage",
            "sqs:GetQueueUrl",
            "sqs:ListQueues",
            "sqs:ChangeMessageVisibility",
            "sqs:SendMessageBatch",
            "sqs:ReceiveMessage",
            "sqs:SendMessage",
            "sqs:GetQueueAttributes",
            "sqs:ListQueueTags",
            "sqs:ListDeadLetterSourceQueues",
            "sqs:DeleteMessageBatch",
            "sqs:PurgeQueue",
            "sqs:DeleteQueue",
            "sqs:CreateQueue",
            "sqs:ChangeMessageVisibilityBatch",
            "sqs:SetQueueAttributes"
          ]
          Resource = aws_sqs_queue.sumo_cw_dead_letter_queue.arn
        },
      ]
    })
  }
  inline_policy {
    name = "CloudWatchCreateLogsRolePolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ]
          Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        },
      ]
    })
  }
  inline_policy {
    name = "InvokeLambdaRolePolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "lambda:InvokeFunction"
          ]
          Resource = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.sumo_dlq_lambda_name}"
        },
      ]
    })
  }
}

resource "aws_lambda_function" "sumo_cw_logs_lambda" {
  function_name = var.sumo_cwlogs_lambda_name
  handler = "cloudwatchlogs_lambda.handler"
  role = aws_iam_role.sumo_cw_lambda_execution_role.arn
  runtime = "nodejs12.x"
  s3_bucket = var.region_map[data.aws_region.current.name]["bucketname"]
  s3_key = "cloudwatchlogs-with-dlq.zip"
  timeout = 300
  dead_letter_config {
    target_arn = aws_sqs_queue.sumo_cw_dead_letter_queue.arn
  }
  memory_size = 128
  environment {
    variables = {
      SUMO_ENDPOINT = var.collection_endpoint
      LOG_FORMAT = var.log_format
      INCLUDE_LOG_INFO = var.loggroup_info
    }
  }

  depends_on = [
    aws_iam_role.sumo_cw_lambda_execution_role,
    aws_sqs_queue.sumo_cw_dead_letter_queue]
}

resource "aws_lambda_permission" "sumo_cw_events_invoke_lambda_permission" {
  action = "lambda:InvokeFunction"
  function_name = var.sumo_dlq_lambda_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.sumo_cw_process_dlq_schedule_rule.arn
}

resource "aws_cloudwatch_event_rule" "sumo_cw_process_dlq_schedule_rule" {
  description = "Events rule for Cron"
  schedule_expression = "rate(5 minutes)"
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "sumo_cw_process_dlq_schedule_target" {
  arn = aws_lambda_function.sumo_cw_process_dlq_lambda.arn
  rule = aws_cloudwatch_event_rule.sumo_cw_process_dlq_schedule_rule.name
}

resource "aws_lambda_function" "sumo_cw_process_dlq_lambda" {
  function_name = var.sumo_dlq_lambda_name
  handler = "DLQProcessor.handler"
  role = aws_iam_role.sumo_cw_lambda_execution_role.arn
  runtime = "nodejs12.x"
  s3_bucket = var.region_map[data.aws_region.current.name]["bucketname"]
  s3_key = "cloudwatchlogs-with-dlq.zip"
  timeout = 300
  dead_letter_config {
    target_arn = aws_sqs_queue.sumo_cw_dead_letter_queue.arn
  }
  memory_size = 128
  environment {
    variables = {
      SUMO_ENDPOINT = var.collection_endpoint
      TASK_QUEUE_URL = aws_sqs_queue.sumo_cw_dead_letter_queue.id
      NUM_OF_WORKERS = var.workers
      LOG_FORMAT = var.log_format
      INCLUDE_LOG_INFO = var.loggroup_info
    }
  }

  depends_on = [
    aws_iam_role.sumo_cw_lambda_execution_role,
    aws_sqs_queue.sumo_cw_dead_letter_queue]
}

resource "aws_sns_topic" "sumo_cw_email_sns_topic" {}

resource "aws_sns_topic_subscription" "sumo_cw_email_sns_topic_subscription" {
  endpoint = var.cfn_update_email
  protocol = "email"
  topic_arn = aws_sns_topic.sumo_cw_email_sns_topic.arn
}

resource "aws_cloudwatch_metric_alarm" "sumo_cw_spillover_alarm" {
  alarm_actions = [
    aws_sns_topic.sumo_cw_email_sns_topic.arn
  ]
  alarm_name = "SumoCWSpilloverAlarm"
  alarm_description = "Notify via email if number of messages in DeadLetterQueue exceeds threshold"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    Name = "QueueName",
    Value = aws_sqs_queue.sumo_cw_dead_letter_queue.name
  }
  evaluation_periods = 1
  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace = "AWS/SQS"
  period = 3600
  statistic = "Sum"
  threshold = 100000

  depends_on = [
    aws_sns_topic.sumo_cw_email_sns_topic,
    aws_sqs_queue.sumo_cw_dead_letter_queue
  ]
}
