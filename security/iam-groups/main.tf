module "iam_policies" {
  source = "../iam-policies"

  aws_account_id               = var.aws_account_id
  require_mfa_iam_self_mgmt    = var.require_mfa
  require_mfa_to_assume_role   = var.require_mfa
  allow_access_to_account_arns = [for group_map in var.iam_groups_for_cross_account_access : group_map.role_arns]
}

# Create a group for users that are able to manage their own IAM user 
# Allows users to update access key and mfa but not set their own permissions
# All users are a member of this group. Forces MFA enabled for all users. Until
# MFA is enabled, they can do nothing else.

resource "aws_iam_group" "iam_self_mgmt" {
  name = var.iam_self_mgmt_group_name
}

resource "aws_iam_group_policy_attachment" "iam_self_mgmt" {
  group      = aws_iam_group.iam_self_mgmt.name
  policy_arn = aws_iam_policy.iam_self_mgmt.arn
}

resource "aws_iam_policy" "iam_self_mgmt" {
  name        = var.iam_self_mgmt_policy_name
  description = "Allow a User to manage their self, but not others. Does not allow User to manage their own permissions."
  policy      = module.iam_policies.iam_self_mgmt_policy
}


# Create groups that can assume roles in other AWS accounts. Takes a list of maps in order
# to accommodate an arbitray number of accounts and groups.

resource "aws_iam_group" "cross_account_access_groups" {
  count = length(var.iam_groups_for_cross_account_access)
  name  = lookup(var.iam_groups_for_cross_account_access[count.index], "group_name")
}


resource "aws_iam_group_policy" "cross_account_access" {
  count  = length(var.iam_groups_for_cross_account_access)
  name   = lookup(var.iam_groups_for_cross_account_access[count.index], "group_name")
  group  = aws_iam_group.cross_account_access_groups[count.index].id
  policy = element(module.iam_policies.allow_access_to_accounts_policies, count.index)
}

