data "aws_iam_policy_document" "full_access" {
  statement {
    sid       = "FullAccess"
    actions   = ["*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "billing_access" {
  statement {
    sid = "BillingAccess"
    actions = [
      "aws-portal:*",
      "budgets:*",
      "cur:*",
      "ce:*",
      "pricing:*",
      "purchase-orders:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "dev_access" {
  statement {
    sid       = "DevAccess"
    actions   = formatlist("%s:*", var.dev_services)
    resources = ["*"]
  }
}

data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "allow_access_from_accounts" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.allow_access_from_account_arns
    }

    dynamic "condition" {
      for_each = var.require_mfa_to_assume_role ? [local.mfa_condition] : []
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "allow_access_to_accounts" {
  count = length(var.allow_access_to_account_arns)

  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = element(var.allow_access_to_account_arns, count.index)
  }
}

data "aws_iam_policy_document" "iam_self_mgmt" {
  statement {
    sid = "SelfManagement"

    actions = [
      "iam:ChangePassword",
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:DeactivateMFADevice",
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:DeleteSSHPublicKey",
      "iam:DeleteVirtualMFADevice",
      "iam:GenerateCredentialReport",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:Get*",
      "iam:List*",
      "iam:ResyncMFADevice",
      "iam:UpdateAccessKey",
      "iam:UpdateLoginProfile",
      "iam:UpdateSSHPublicKey",
      "iam:UpdateUser",
      "iam:UploadSigningCertificate",
      "iam:UploadSSHPublicKey",
    ]

    # escape '$' woth $$ to render '${aws:username}' into policy
    resources = [
      "arn:aws:iam::${var.aws_account_id}:mfa/$${aws:username}",
      "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}",
    ]

    effect = "Allow"

    dynamic "condition" {
      for_each = var.require_mfa_iam_self_mgmt ? [local.mfa_condition] : []
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }

  # allow MFA setup without MFA
  statement {
    sid = "SelfManagementWithoutMFA"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
    ]

    resources = [
      "arn:aws:iam::${var.aws_account_id}:mfa/$${aws:username}",
      "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}",
    ]

    effect = "Allow"
  }

  statement {
    sid = "SelfManagementWildcardWithoutMFA"

    actions = [
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SelfManagementWildcard"

    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetGroupPolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetServiceLastAccessedDetails",
      "iam:ListAttachedGroupPolicies",
      "iam:ListEntitiesForPolicy",
      "iam:ListGroups",
      "iam:ListGroupPolicies",
      "iam:ListUsers",
      "iam:ListPolicyVersions",
    ]

    resources = ["*"]
    effect    = "Allow"
    dynamic "condition" {
      for_each = var.require_mfa_iam_self_mgmt ? [local.mfa_condition] : []
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

locals {
  mfa_condition = {
    test     = "Bool"
    variable = "aws:MultiFactorAuthPresent"
    values   = ["true"]
  }
}
