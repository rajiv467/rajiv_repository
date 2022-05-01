/* Common policies, roles, users and groups to set up
*/

# SAML trust policy
data "template_file" "saml_trust" {
  template = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRoleWithSAML",
            "Effect": "Allow",
            "Condition": {
                "StringEquals": {
                    "saml:iss": "$${saml_iss}",
                    "SAML:aud": "https://signin.aws.amazon.com/saml"
                }
            },
            "Principal": {
                "Federated": "$${saml_idp_arn}"
            }
        }
    ]
}
EOF

  vars = {
    saml_iss     = var.saml_iss
    saml_idp_arn = var.saml_idp_arn
  }
}

/* Password policy */
resource "aws_iam_account_password_policy" "c4_pp" {
  minimum_password_length        = 14
  max_password_age               = 60
  allow_users_to_change_password = true
  password_reuse_prevention      = 24

  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers              = true
  require_symbols              = true
}

/* C4 Admin */
# policy
resource "aws_iam_policy" "c4_admin" {
  name        = "c4admin-pol${var.name_suffix}"
  description = "Channel 4 admin user policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF

}

# role
resource "aws_iam_role" "c4_admin" {
  name                 = "c4admin-role${var.name_suffix}"
  path                 = "/federated-user/"
  max_session_duration = "14400"
  assume_role_policy   = data.template_file.saml_trust.rendered
}

# group
resource "aws_iam_group" "c4_admin" {
  name = "c4-admins"
  #name = "c4admin-grp${var.name_suffix}"
}

# group membership
resource "aws_iam_group_membership" "c4_admin" {
  name = "c4admin-mem${var.name_suffix}"

  users = [
    aws_iam_user.nhunter.name,
    aws_iam_user.mrichardson.name,
  ]

  group = aws_iam_group.c4_admin.name
}

# users (emergency admins)
resource "aws_iam_user" "nhunter" {
  name          = "neil.hunter@piksel.com"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "nhunter" {
  user = aws_iam_user.nhunter.name

  # if the user has a keybase user then we can
  # send encrypted password
  pgp_key = "keybase:neildothunter"
}

resource "aws_iam_user" "mrichardson" {
  name          = "mark.richardson@piksel.com"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "mrichardson" {
  user = aws_iam_user.mrichardson.name

  # if no keybase user then MST will have to decrypt
  # password and send through secure channel
  pgp_key = var.pub_gpg_key
}

# attachment for federated and CI access (seperate policy and attachment from emergency user access on purpose)
resource "aws_iam_role_policy_attachment" "c4_admin_federated" {
  role       = aws_iam_role.c4_admin.name
  policy_arn = aws_iam_policy.c4_admin.arn
}

resource "aws_iam_role_policy_attachment" "c4_admin_ci" {
  role       = aws_iam_role.terraform_ci_governance_audit.name
  policy_arn = aws_iam_policy.c4_admin.arn
}

# attachment for emergency access (seperate policy and attachment from federated access on purpose)
resource "aws_iam_group_policy_attachment" "c4_admin" {
  group      = aws_iam_group.c4_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

/* Governance Audit role */
resource "aws_iam_role" "terraform_ci_governance_audit" {
  name = "tf_ci_governance_audit-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.tfcigovernanceaudit_role_arn}"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "${var.tfcigovernanceaudit_external_id}"
                }
            }
        }
    ]
}
EOF

}

/* this policy allows TF plan but not apply
resource "aws_iam_policy" "terraform_ci_governance_audit" {
  name = "terraform_ci_governance_audit-pol${null_resource.interpol_vars.triggers.name_suffix}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAuditServiceAccess",
            "Action": [
                "cloudtrail:*",
                "cloudwatch:*",
                "config:*",
                "dynamodb:*",
                "events:*",
                "lambda:*",
                "sns:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "AllowIAMRoleAccess",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:ListRoles"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "AllowIAMPolicyAccess",
            "Action": [
                "iam:AttachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:GetPolicy",
                "iam:ListEntitiesForPolicy"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
*/

/* C4 Power */
# policy
resource "aws_iam_policy" "c4_power" {
  name        = "c4power-pol${var.name_suffix}"
  description = "Channel 4 power user policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "NotAction": "iam:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowPowerUsersToManageTheirIAMCredentials",
            "Effect": "Allow",
            "Action": [
                "iam:*AccessKey*",
                "iam:*SSHPublicKey*"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        }
    ]
}
EOF

}

# role
resource "aws_iam_role" "c4_power" {
  name                 = "c4power-role${var.name_suffix}"
  path                 = "/federated-user/"
  max_session_duration = "14400"
  assume_role_policy   = data.template_file.saml_trust.rendered
}

# group
resource "aws_iam_group" "c4_power" {
  name = "c4-powerusers"
  #name = "c4power-grp${var.name_suffix}"
}

# users

# attachment
resource "aws_iam_role_policy_attachment" "c4_power" {
  role       = aws_iam_role.c4_power.name
  policy_arn = aws_iam_policy.c4_power.arn
}

resource "aws_iam_group_policy_attachment" "c4_power" {
  group      = aws_iam_group.c4_power.name
  policy_arn = aws_iam_policy.c4_power.arn
}

/* C4 Suport (RO) */
# policy (uses managed ReadOnlyAccess policy)

# role
resource "aws_iam_role" "c4_support" {
  name                 = "c4support-role${var.name_suffix}"
  path                 = "/federated-user/"
  max_session_duration = "14400"
  assume_role_policy   = data.template_file.saml_trust.rendered
}

# group
resource "aws_iam_group" "c4_support" {
  name = "c4-support"
  #name = "c4support-grp${var.name_suffix}"
}

# users

# attachment
resource "aws_iam_role_policy_attachment" "c4_support_federated" {
  role       = aws_iam_role.c4_support.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "c4_support" {
  group      = aws_iam_group.c4_support.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# C4 SRE (RO / Power Users / support) */
# SRE requires Power user in nmsandbox
# SRE requires RO / AWS Support access origin / nmprod / nmpreprod
# policy (uses managed ReadOnlyAccess policy)
# Policy (uses managed AWS Support access policy)
# policy (power user policy for nmsandbox - currently offline)

# role
resource "aws_iam_role" "c4_sre" {
  name                 = "c4sre-role${var.name_suffix}"
  path                 = "/federated-user/"
  max_session_duration = "14400"
  assume_role_policy   = data.template_file.saml_trust.rendered
}

# group
resource "aws_iam_group" "c4_sre" {
  name = "c4-sre"

  #name = "c4sre-grp${var.name_suffix}"
}

# users

# attachment
resource "aws_iam_role_policy_attachment" "c4_sre_federated_1" {
  role       = aws_iam_role.c4_sre.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "c4_sre_federated_2" {
  role       = aws_iam_role.c4_sre.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

/* C4 Billing */
# policy
resource "aws_iam_policy" "c4_billing" {
  name        = "c4billing-pol${var.name_suffix}"
  description = "Channel 4 billing user policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "aws-portal:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF

}

# role
resource "aws_iam_role" "c4_billing" {
  name                 = "c4billing-role${var.name_suffix}"
  path                 = "/federated-user/"
  max_session_duration = "14400"
  assume_role_policy   = data.template_file.saml_trust.rendered
}

# group
resource "aws_iam_group" "c4_billing" {
  name = "c4-billing"
  #name = "c4billing-grp${var.name_suffix}"
}

# users

# attachment
resource "aws_iam_role_policy_attachment" "c4_billing" {
  role       = aws_iam_role.c4_billing.name
  policy_arn = aws_iam_policy.c4_billing.arn
}

resource "aws_iam_group_policy_attachment" "c4_billing" {
  group      = aws_iam_group.c4_billing.name
  policy_arn = aws_iam_policy.c4_billing.arn
}

/* Enforce MFA and allow users to self-service on IAM
Derived from https://www.trek10.com/blog/improving-the-aws-force-mfa-policy-for-IAM-users/
and http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_delegate-permissions_examples.html
*/
# policy
resource "aws_iam_policy" "c4_mfa" {
  name        = "c4mfa-pol${var.name_suffix}"
  description = "Enforce use of MFA"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllUsersToListAccounts",
            "Effect": "Allow",
            "Action": [
                "iam:ListAccount*",
                "iam:GetAccountSummary",
                "iam:GetAccountPasswordPolicy",
                "iam:ListUsers"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "AllowIndividualUserToManageTheirPasswords",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:*LoginProfile"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToListTheirMFA",
            "Effect": "Allow",
            "Action": [
                "iam:ListVirtualMFADevices",
                "iam:ListMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:mfa/*",
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToManageTheirMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "DenyEverythingExceptForBelowUnlessMFAd",
            "Effect": "Deny",
            "NotAction": [
                "iam:ListVirtualMFADevices",
                "iam:ListMFADevices",
                "iam:ListUsers",
                "iam:ListAccountAliases",
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:ChangePassword",
                "iam:CreateLoginProfile",
                "iam:DeleteLoginProfile",
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary",
                "iam:GetLoginProfile",
                "iam:UpdateLoginProfile"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:MultiFactorAuthAge": "true"
                }
            }
        },
        {
            "Sid": "DenyIamAccessToOtherAccountsUnlessMFAd",
            "Effect": "Deny",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeactivateMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:ChangePassword",
                "iam:CreateLoginProfile",
                "iam:DeleteLoginProfile",
                "iam:GetAccountSummary",
                "iam:GetLoginProfile",
                "iam:UpdateLoginProfile"
            ],
            "NotResource": [
                "arn:aws:iam::${var.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ],
            "Condition": {
                "Null": {
                    "aws:MultiFactorAuthAge": "true"
                }
            }
        }
    ]
}
EOF

}

# role

# group

# users

# attachment
resource "aws_iam_group_policy_attachment" "c4_mfa_admin" {
  group      = aws_iam_group.c4_admin.name
  policy_arn = aws_iam_policy.c4_mfa.arn
}

resource "aws_iam_group_policy_attachment" "c4_mfa_power" {
  group      = aws_iam_group.c4_power.name
  policy_arn = aws_iam_policy.c4_mfa.arn
}

resource "aws_iam_group_policy_attachment" "c4_mfa_support" {
  group      = aws_iam_group.c4_support.name
  policy_arn = aws_iam_policy.c4_mfa.arn
}

resource "aws_iam_group_policy_attachment" "c4_mfa_billing" {
  group      = aws_iam_group.c4_billing.name
  policy_arn = aws_iam_policy.c4_mfa.arn
}

/* Manage IAM Keys
To be used un conjunction with c4_mfa to extend perms
*/
# policy
resource "aws_iam_policy" "c4_managekey" {
  name        = "c4managekey-pol${var.name_suffix}"
  description = "Enforce use of MFA"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid":"AllowPowerUsersToManageTheirIAMKeys",
            "Effect": "Allow",
            "Action": [
                "iam:*AccessKey*"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        }
    ]
}
EOF

}

# role

# group

# users

# attachment

/* Provide group to suspend users */
# policy
resource "aws_iam_policy" "c4_suspended" {
  name        = "c4suspended-pol${var.name_suffix}"
  description = "Enforce use of MFA"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Deny"
        }
    ]
}
EOF

}

# role

# group
resource "aws_iam_group" "c4_suspended" {
  name = "c4-suspendedusers"
  #name = "c4suspended-grp${var.name_suffix}"
}

# users

# attachment
resource "aws_iam_group_policy_attachment" "c4_suspended" {
  group      = aws_iam_group.c4_suspended.name
  policy_arn = aws_iam_policy.c4_suspended.arn
}

/* Provide group to register service accounts */
# policy

# role

# group
resource "aws_iam_group" "c4_service" {
  name = "c4-serviceaccounts"
  #name = "c4suspended-grp${var.name_suffix}"
}

/* Deny
# Explicit deny policy
# ref. http://docs.aws.amazon.com/IAM/latest/UserGuide/list_iam.html
*/
# policy
resource "aws_iam_policy" "c4_deny" {
  name        = "c4deny-pol${var.name_suffix}"
  description = "Explictly deny access to audit and IAM"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyAccessToAuditTools",
            "Effect": "Deny",
            "Action": [
                "cloudtrail:*",
                "config:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyAccessToCustomConfigRules",
            "Effect": "Deny",
            "Action": [
                "lambda:*"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:rule*"
            ]
        },
        {
            "Sid": "DenyIAMManipulation",
            "Effect": "Deny",
            "Action": [
                "iam:*InstanceProfile",
                "iam:AddUserToGroup",
                "iam:*Group*",
                "iam:*OpenIDConnectProvider",
                "iam:*GroupPolicy",
                "iam:*RolePolicy",
                "iam:*UserPolicy",
                "iam:*AccountAlias",
                "iam:CreatePolicy",
                "iam:*PolicyVersion",
                "iam:CreateRole",
                "iam:*SAMLProvider",
                "iam:CreateUser",
                "iam:DeleteAccountPasswordPolicy",
                "iam:DeletePolicy",
                "iam:DeleteRole",
                "iam:*Certificate",
                "iam:DeleteUser",
                "iam:*Report",
                "iam:GetAccountAuthorizationDetails",
                "iam:*ContextKeys*",
                "iam:GetPolicy",
                "iam:GetRole",
                "iam:ListAttachedGroupPolicies",
                "iam:ListAttachedUserPolicies",
                "iam:ListEntitiesForPolicy",
                "iam:*GroupPolicies",
                "iam:*UserPolicies",
                "iam:RemoveUserFromGroup",
                "iam:UpdateAccountPasswordPolicy",
                "iam:UpdateUser"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

# role

# group

# users

# attachment
resource "aws_iam_role_policy_attachment" "c4_deny_power" {
  role       = aws_iam_role.c4_power.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

resource "aws_iam_role_policy_attachment" "c4_deny_support" {
  role       = aws_iam_role.c4_support.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

resource "aws_iam_group_policy_attachment" "c4_deny_power" {
  group      = aws_iam_group.c4_power.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

resource "aws_iam_group_policy_attachment" "c4_deny_service" {
  group      = aws_iam_group.c4_service.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

resource "aws_iam_group_policy_attachment" "c4_deny_support" {
  group      = aws_iam_group.c4_support.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

resource "aws_iam_group_policy_attachment" "c4_deny_sre" {
  group      = aws_iam_group.c4_sre.name
  policy_arn = aws_iam_policy.c4_deny.arn
}

# resource "aws_iam_group_policy_attachment" "c4_deny_sre" {
#   group      = "${aws_iam_group.c4_sre.name}"
#   policy_arn = "${aws_iam_policy.c4_deny.arn}"
# }
