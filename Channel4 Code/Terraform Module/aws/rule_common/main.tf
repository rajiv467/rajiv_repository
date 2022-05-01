/* Config rules whitelists DynamoDB table */
resource "aws_dynamodb_table" "config_rules_whitelists" {
  name           = "config_rules_whitelists-ddb${var.name_suffix}"
  read_capacity  = 10
  write_capacity = 2
  hash_key       = "WhitelistName"
  range_key      = "Account"

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "WhitelistName"
    type = "S"
  }

  attribute {
    name = "Account"
    type = "S"
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = merge(
    var.default_tags,
    {
      "Name" = "config_rules_whitelists-ddb${var.name_suffix}"
    },
  )
}

/* Common Config Rules to setup
*/

/* Ensure CloudTrail enabled */
resource "aws_config_config_rule" "ctenabled" {
  name        = "ctenabled-rul${var.name_suffix}"
  description = "Checks whether CloudTrail is enabled on the account."

  input_parameters = <<EOF
{
    "s3BucketName": "${var.cloudtrail_s3_id}"
}
EOF


  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }
}

/* Root MFA enabled */
resource "aws_config_config_rule" "rootmfaenabled" {
  name        = "rootmfaenabled-rul${var.name_suffix}"
  description = "Checks whether root has MFA enabled for console access."

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
}

/* User MFA Enabled */
# create function
module "lambda_usermfaenabled" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.usermfaenabled["name"]
  description = var.usermfaenabled["description"]

  src_hash = var.usermfaenabled["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.usermfaenabled["dst_s3_key"]

  runtime = var.usermfaenabled["runtime"]
  memory  = var.usermfaenabled["memory"]
  timeout = var.usermfaenabled["timeout"]
  policy  = var.usermfaenabled["policy"]
  handler = var.usermfaenabled["handler"]

  is_crit           = var.usermfaenabled["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.usermfaenabled, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.usermfaenabled, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.usermfaenabled, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.usermfaenabled["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_usermfaenabled" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_usermfaenabled.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "usermfaenabled" {
  name        = "usermfaenabled-rul${var.name_suffix}"
  description = var.usermfaenabled["description"]

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_usermfaenabled.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::IAM::User",
    ]
  }
}

/* EIP attached */
resource "aws_config_config_rule" "eipattached" {
  name        = "eipattached-rul${var.name_suffix}"
  description = "Checks whether all EIP addresses allocated to a VPC are attached to EC2 instances or in-use ENIs."

  source {
    owner             = "AWS"
    source_identifier = "EIP_ATTACHED"
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::EIP",
    ]
  }
}

/* Restrict Ports */
# create function
module "lambda_restrictports" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.restrictports["name"]
  description = var.restrictports["description"]

  src_hash = var.restrictports["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.restrictports["dst_s3_key"]

  runtime = var.restrictports["runtime"]
  memory  = var.restrictports["memory"]
  timeout = var.restrictports["timeout"]
  policy  = var.restrictports["policy"]
  handler = var.restrictports["handler"]

  is_crit           = var.restrictports["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.restrictports, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.restrictports, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.restrictports, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.restrictports["invocations_per_hour"]

  env_vars = {
    WHITELIST_TABLE   = aws_dynamodb_table.config_rules_whitelists.id
    WHITELIST_CONTEXT = var.restrictports["whitelist_context"]
  }

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_restrictports" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_restrictports.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "restrictports" {
  name        = "restrictports-rul${var.name_suffix}"
  description = var.restrictports["description"]

  input_parameters = <<EOF
{
    "range1": "20-23",
    "mysql": "3306",
    "rdp": "3389",
    "netsh": "1443",
    "oracle": "1520-1530",
    "mssql": "1433-1434",
    "psql": "5432"
}
EOF


  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_restrictports.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::SecurityGroup",
    ]
  }
}

/* Flow logs Enabled */
# create function
module "lambda_flowlogsenabled" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.flowlogsenabled["name"]
  description = var.flowlogsenabled["description"]

  src_hash = var.flowlogsenabled["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.flowlogsenabled["dst_s3_key"]

  runtime = var.flowlogsenabled["runtime"]
  memory  = var.flowlogsenabled["memory"]
  timeout = var.flowlogsenabled["timeout"]
  policy  = var.flowlogsenabled["policy"]
  handler = var.flowlogsenabled["handler"]

  is_crit           = var.flowlogsenabled["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.flowlogsenabled, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.flowlogsenabled, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.flowlogsenabled, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.flowlogsenabled["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_flowlogsenabled" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_flowlogsenabled.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "flowlogsenabled" {
  name        = "flowlogsenabled-rul${var.name_suffix}"
  description = var.flowlogsenabled["description"]

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_flowlogsenabled.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::VPC",
    ]
  }
}

/* Instances in VPC */
# create function
module "lambda_instancesinvpc" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.instancesinvpc["name"]
  description = var.instancesinvpc["description"]

  src_hash = var.instancesinvpc["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.instancesinvpc["dst_s3_key"]

  runtime = var.instancesinvpc["runtime"]
  memory  = var.instancesinvpc["memory"]
  timeout = var.instancesinvpc["timeout"]
  policy  = var.instancesinvpc["policy"]
  handler = var.instancesinvpc["handler"]

  is_crit           = var.instancesinvpc["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.instancesinvpc, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.instancesinvpc, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.instancesinvpc, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.instancesinvpc["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_instancesinvpc" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_instancesinvpc.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "instancesinvpc" {
  name        = "instancesinvpc-rul${var.name_suffix}"
  description = var.instancesinvpc["description"]

  input_parameters = <<EOF
{
    "vpcTagKey": "Terraform",
    "vpcTagValue": "true"
}
EOF


  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_instancesinvpc.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::Instance",
    ]
  }
}

/* Resource tagging
Resource ref. http://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html
If we enable on full set of Config supported resources that can also be tagged:
            "AWS::ElasticLoadBalancingV2::LoadBalancer",
            "AWS::ACM::Certificate",
            "AWS::EC2::Volume",
            "AWS::EC2::Instance",
            "AWS::EC2::SecurityGroup",
            "AWS::RDS::DBInstance",
            "AWS::RDS::DBSecurityGroup",
            "AWS::RDS::DBSnapshot",
            "AWS::RDS::DBSubnetGroup",
            "AWS::RDS::EventSubscription",
            "AWS::S3::Bucket",
            "AWS::EC2::CustomerGateway",
            "AWS::EC2::InternetGateway",
            "AWS::EC2::NetworkAcl",
            "AWS::EC2::RouteTable",
            "AWS::EC2::Subnet",
            "AWS::EC2::VPC",
            "AWS::EC2::VPNConnection",
            "AWS::EC2::VPNGateway"
.. then we face the problem of default resources. Delete them - What about other regions?
Tag them - bit of a faff? For now am going to shrink the list to remove VPC objects.
*/
resource "aws_config_config_rule" "requiredtags" {
  name        = "requiredtags-rul${var.name_suffix}"
  description = "Checks whether your resources have the tags that you specify."

  input_parameters = <<EOF
{
    "tag1Key": "Environment",
    "tag2Key": "Owner",
    "tag3Key": "Project",
    "tag4Key": "ReviewDate",
    "tag5Key": "Name"
}
EOF


  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::Instance",
      "AWS::RDS::DBInstance",
    ]
  }
}

/* Service User AWS Console Access Disabled */
# create function
module "lambda_serviceuserconsoledisabled" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.serviceuserconsoledisabled["name"]
  description = var.serviceuserconsoledisabled["description"]

  src_hash = var.serviceuserconsoledisabled["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.serviceuserconsoledisabled["dst_s3_key"]

  runtime = var.serviceuserconsoledisabled["runtime"]
  memory  = var.serviceuserconsoledisabled["memory"]
  timeout = var.serviceuserconsoledisabled["timeout"]
  policy  = var.serviceuserconsoledisabled["policy"]
  handler = var.serviceuserconsoledisabled["handler"]

  is_crit           = var.serviceuserconsoledisabled["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.serviceuserconsoledisabled, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.serviceuserconsoledisabled, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.serviceuserconsoledisabled, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.serviceuserconsoledisabled["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_serviceuserconsoledisabled" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_serviceuserconsoledisabled.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "serviceuserconsoledisabled" {
  name        = "serviceuserconsoledisabled-rul${var.name_suffix}"
  description = var.serviceuserconsoledisabled["description"]

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_serviceuserconsoledisabled.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::IAM::User",
    ]
  }
}

/* IAM Entities With Powerful Policies Attached */
# create function
module "lambda_powerfulactionsallowed" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.powerfulactionsallowed["name"]
  description = var.powerfulactionsallowed["description"]

  src_hash = var.powerfulactionsallowed["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.powerfulactionsallowed["dst_s3_key"]

  runtime = var.powerfulactionsallowed["runtime"]
  memory  = var.powerfulactionsallowed["memory"]
  timeout = var.powerfulactionsallowed["timeout"]
  policy  = var.powerfulactionsallowed["policy"]
  handler = var.powerfulactionsallowed["handler"]

  is_crit           = var.powerfulactionsallowed["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.powerfulactionsallowed, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.powerfulactionsallowed, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.powerfulactionsallowed, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.powerfulactionsallowed["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_powerfulactionsallowed" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_powerfulactionsallowed.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "powerfulactionsallowed" {
  name        = "powerfulactionsallowed-rul${var.name_suffix}"
  description = var.powerfulactionsallowed["description"]

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_powerfulactionsallowed.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::IAM::User",
      "AWS::IAM::Group",
      "AWS::IAM::Role",
      "AWS::IAM::Policy",
    ]
  }
}

/* EBS volumes not in use - AWS managed rule
https://docs.aws.amazon.com/config/latest/developerguide/ec2-volume-inuse-check.html
*/
resource "aws_config_config_rule" "unusedvolumes" {
  name        = "unusedvolumes-rul${var.name_suffix}"
  description = "Checks whether EBS volumes are attached to EC2 instance."

  source {
    owner             = "AWS"
    source_identifier = "EC2_VOLUME_INUSE_CHECK"
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::Volume",
    ]
  }
}

/* Unused IAM User Credentials */
# create function
module "lambda_usercredsnotused" {
  source = "git::ssh://git@gitlab.channel4.com/gis-channel4/terraform-modules.git//aws/lambda_function/"

  name_suffix = var.name_suffix
  name        = var.usercredsnotused["name"]
  description = var.usercredsnotused["description"]

  src_hash = var.usercredsnotused["src_hash"]

  dst_s3_id  = var.dst_s3_id
  dst_s3_key = var.usercredsnotused["dst_s3_key"]

  runtime = var.usercredsnotused["runtime"]
  memory  = var.usercredsnotused["memory"]
  timeout = var.usercredsnotused["timeout"]
  policy  = var.usercredsnotused["policy"]
  handler = var.usercredsnotused["handler"]

  is_crit           = var.usercredsnotused["is_crit"]
  mstwarn_topic_arn = var.mstwarn_topic_arn
  mstcrit_topic_arn = var.mstcrit_topic_arn

  /* seems that value from remote state is not interpolated before count tries to strconv.ParseInt. Setting here seems to fix it.
                                        alert_on_error = "${lookup(var.usercredsnotused, "alert_on_error")}"
                                        alert_on_duration = "${lookup(var.usercredsnotused, "alert_on_duration")}"
                                        alert_on_throttle = "${lookup(var.usercredsnotused, "alert_on_throttle")}"
                                        */
  alert_on_error = true

  alert_on_duration    = true
  alert_on_throttle    = true
  invocations_per_hour = var.usercredsnotused["invocations_per_hour"]

  default_tags = var.default_tags
}

# add trigger
resource "aws_lambda_permission" "lambda_usercredsnotused" {
  statement_id  = "AllowExecutionFromConfig"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_usercredsnotused.function_arn
  principal     = "config.amazonaws.com"

  # tie this down to from same account
  source_account = var.account_id
}

resource "aws_config_config_rule" "usercredsnotused" {
  name        = "usercredsnotused-rul${var.name_suffix}"
  description = var.usercredsnotused["description"]

  input_parameters = <<EOF
{
    "maxInactiveDays": "180",
    "maxGraceDays": "30"
}
EOF


  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = module.lambda_usercredsnotused.function_arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::IAM::User",
    ]
  }
}

/* IAM password policies are enabled and within specified requirements - AWS managed rule
https://docs.aws.amazon.com/config/latest/developerguide/iam-password-policy.html
*/
resource "aws_config_config_rule" "iampasswordpolicy" {
  name        = "iampasswordpolicy-rul${var.name_suffix}"
  description = "Checks whether the account password policy meets the specified requirements."

  input_parameters = <<EOF
{
    "RequireUppercaseCharacters": "true",
    "RequireLowercaseCharacters": "true",
    "RequireSymbols": "true",
    "RequireNumbers": "true",
    "MinimumPasswordLength": "14",
    "PasswordReusePrevention": "24",
    "MaxPasswordAge": "60"
}
EOF


  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}

