/* Enable and configure *Account* level audit services */

/* CloudTrail */
resource "aws_cloudtrail" "trail" {
  name                          = "gen-trail${var.name_suffix}"
  s3_bucket_name                = var.cloudtrail_s3_id
  is_multi_region_trail         = var.cloudtrail_multi_region
  include_global_service_events = var.cloudtrail_global_events
  enable_log_file_validation    = var.cloudtrail_log_file_validation

  /*cloud_watch_logs_role_arn = "${}"
    cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.trail.arn}"*/

  tags = var.default_tags
}

/*resource "aws_cloudwatch_log_group" "trail" {
  name = "cloudtrail-lg${var.name_suffix}"
  retention_in_days = "${var.cloudtrail_log_group_retention}"
}*/

/* AWS Config
- Recorder: Detects changes and generates configuration items (CIs) for supported resources
on the account.
- CI: Configuration items are supplied as a configuration stream and a configuration snapshot.
*/
resource "aws_config_configuration_recorder" "config" {
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "config" {
  depends_on = [aws_config_delivery_channel.config]

  name       = aws_config_configuration_recorder.config.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "config" {
  depends_on = [aws_config_configuration_recorder.config]

  s3_bucket_name = var.config_s3_id
  sns_topic_arn  = var.config_topic_arn

  snapshot_delivery_properties {
    delivery_frequency = "Twelve_Hours"
  }
}

# IAM Role
resource "aws_iam_role" "config" {
  name = "config-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ConfigTrust",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

# Use AWS managed policy
resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

/* Config Health Check */
# create function
module "lambda_confighealth" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.confighealth["name"]
  description = var.confighealth["description"]

  src_hash = var.confighealth["src_hash"]

  dst_s3_id  = var.lambda_s3_id
  dst_s3_key = var.confighealth["dst_s3_key"]

  runtime = var.confighealth["runtime"]
  memory  = var.confighealth["memory"]
  timeout = var.confighealth["timeout"]
  policy  = var.confighealth["policy"]
  handler = var.confighealth["handler"]

  is_crit           = var.confighealth["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                    alert_on_error = "${lookup(var.confighealth, "alert_on_error")}"
                    alert_on_duration = "${lookup(var.confighealth, "alert_on_duration")}"
                    alert_on_throttle = "${lookup(var.confighealth, "alert_on_throttle")}"
                    */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.confighealth["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_confighealth" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_confighealth.function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_confighealth.arn
}

resource "aws_cloudwatch_event_rule" "lambda_confighealth" {
  name                = "${var.confighealth["name"]}-er${var.name_suffix}"
  description         = "Poll Config health every hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_confighealth" {
  rule = aws_cloudwatch_event_rule.lambda_confighealth.name
  arn  = module.lambda_confighealth.function_arn

  # replace event obj with constants
  input = <<EOF
{
    "sns_arn" : "${var.mstcrit_topic_arn}",
    "history_frequency_hours" : "${var.config_history_del_hours}",
    "stream_frequency_hours" : "${var.config_stream_del_hours}"
}
EOF

}

/* Config Rules */
module "rule_common" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/rule_common/"

  name_suffix                = var.name_suffix
  lambda_s3_id               = var.lambda_s3_id
  profile                    = var.profile
  cloudtrail_s3_id           = var.cloudtrail_s3_id
  dst_s3_id                  = var.lambda_s3_id
  account_id                 = var.account_id
  usermfaenabled             = var.usermfaenabled
  serviceuserconsoledisabled = var.serviceuserconsoledisabled
  powerfulactionsallowed     = var.powerfulactionsallowed
  usercredsnotused           = var.usercredsnotused
  flowlogsenabled            = var.flowlogsenabled
  restrictports              = var.restrictports
  instancesinvpc             = var.instancesinvpc
  mstwarn_topic_arn          = var.mstwarn_topic_arn
  mstcrit_topic_arn          = var.mstcrit_topic_arn

  default_tags = var.default_tags
}
