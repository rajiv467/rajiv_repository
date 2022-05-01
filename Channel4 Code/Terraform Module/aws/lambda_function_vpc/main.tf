/* CRUD Lamabda functions and common components.
1. IAM role and policy.
2. Function.
3. CW Alerts.

Does not include triggers and trigger permissions.

This should be considered a short-term solution until the existing
lambda_function module can switch between vpc and normal variants - see:
git@gitlab.channel4.com/gis-channel4/terraform-modules.git?ref=lambda_function-vpc_config
are resolved.
*/

# Paramterise error config so diff values can be passed in to default
variable "error_count" {
  default = "1"
}

variable "period_in_seconds" {
  default = "3600" #1hr
}

variable "datapoints_duration" {
  default = "1" # default from AWS
}

variable "datapoints_errors" {
  default = "1" # default from AWS
}

variable "evaluation_periods_errors" {
  default = "1" # existing default before parameterisation. Setting to allow config on alarms
}

variable "evaluation_periods_duration" {
  default = "1" # existing default before parameterisation. Setting to allow config on alarms
}

# IAM role and allow lambda to assume role
resource "aws_iam_role" "lambda" {
  name = "${var.name}-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

# Add role policy
resource "aws_iam_role_policy" "lambda" {
  name   = "${var.name}-pol${var.name_suffix}"
  role   = aws_iam_role.lambda.id
  policy = var.policy
}

# Managed role policy with extra perms for running in a vpc
resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "lambda" {
  s3_bucket = var.dst_s3_id
  s3_key    = var.dst_s3_key

  function_name = "${var.name}-lam${var.name_suffix}"
  description   = var.description

  role        = aws_iam_role.lambda.arn
  handler     = var.handler
  runtime     = var.runtime
  memory_size = var.memory
  timeout     = var.timeout

  reserved_concurrent_executions = var.reserved_concurrent_executions

  layers = length(var.layer_arns) > 0 ? var.layer_arns : null
  /* When conditionals work properly these would only be created when
      var.env_vars exists
      */
  kms_key_arn = var.kms_key_arn

  environment {
    variables = var.env_vars
  }

  # this requires apply running twice to update GH:6901 / GH:4846
  source_code_hash = var.src_hash

  # set to publish
  publish = var.publish

  tags = var.default_tags

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  dynamic "file_system_config" {
    for_each = [for config in var.file_system_configs: {
      arn               = config.arn
      local_mount_path  = config.local_mount_path
    }]

    content {
      arn               = file_system_config.value.arn
      local_mount_path  = file_system_config.value.local_mount_path
    }
  }
}

# set alias to latest
resource "aws_lambda_alias" "lambda_latest" {
  count = var.publish ? 1 : 0

  name             = var.latest_alias
  description      = "${var.latest_alias} alias"
  function_name    = aws_lambda_function.lambda.arn
  function_version = "$LATEST"
}

# CW Alarm based on number of errors
resource "aws_cloudwatch_metric_alarm" "errors" {

  alarm_name          = "${var.name}err-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods_errors
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = var.period_in_seconds
  statistic           = "Sum"
  threshold           = var.error_count
  datapoints_to_alarm = var.datapoints_errors

  # no data points = function not run = 0 errors
  treat_missing_data = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }

  alarm_description = "LambdaFunction.Errors > 1"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  #alarm_actions = [{
  #  "false" = var.mstwarn_topic_arn
  #  "true" = var.mstcrit_topic_arn
  #}[var.is_crit]]
  alarm_actions = (var.is_crit ? [var.mstcrit_topic_arn] : [var.mstwarn_topic_arn])
  count         = var.alert_on_error ? 1 : 0
}

# CW Alarm based on max duration as a percentage of timeout
resource "aws_cloudwatch_metric_alarm" "duration" {
  alarm_name          = "${var.name}dur-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods_errors
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "3600" # 1hr
  statistic           = "Maximum"

  # threshold 90% of timeout value in ms
  threshold = format("%d", var.timeout * 1000) * 0.9

  datapoints_to_alarm = var.datapoints_duration

  # no data points = function not run
  treat_missing_data = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }

  alarm_description = "LambdaFunction.Duration > 90% of timeout"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  #alarm_actions = [{
  #  "false" = var.mstwarn_topic_arn
  #  "true" = var.mstcrit_topic_arn
  #}[var.is_crit]]
  alarm_actions = (var.is_crit ? [var.mstcrit_topic_arn] : [var.mstwarn_topic_arn])
  count         = var.alert_on_duration ? 1 : 0
}

# CW Alarm based on throttles
resource "aws_cloudwatch_metric_alarm" "throttles" {
  alarm_name          = "${var.name}thr-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "3600" # 1hr
  statistic           = "Sum"
  threshold           = "10"

  # no data points = function not run = 0 throttles
  treat_missing_data = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }

  alarm_description = "LambdaFunction.Throttles > 10"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  #alarm_actions = [{
  #  "false" = var.mstwarn_topic_arn
  #  "true" = var.mstcrit_topic_arn
  #}[var.is_crit]]
  alarm_actions = (var.is_crit ? [var.mstcrit_topic_arn] : [var.mstwarn_topic_arn])
  count         = var.alert_on_throttle ? 1 : 0
}

# CW Alarm based on number of invocations
resource "aws_cloudwatch_metric_alarm" "invocations" {
  alarm_name          = "${var.name}inv-ma${var.name_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  period              = "3600" # 1hr
  statistic           = "Sum"
  threshold           = var.invocations_per_hour

  # no data points = function not run = 0 innvocations
  treat_missing_data = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }

  alarm_description = "LambdaFunction.Invocation > configured_max"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  #alarm_actions = [{
  #  "false" = var.mstwarn_topic_arn
  #  "true" = var.mstcrit_topic_arn
  #}[var.is_crit]]
  alarm_actions = (var.is_crit ? [var.mstcrit_topic_arn] : [var.mstwarn_topic_arn])
}
