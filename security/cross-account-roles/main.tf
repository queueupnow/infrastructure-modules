module "full_access_policies" {
  source = "../iam-policies"
  count  = signum(length(var.allow_full_access_from_account_arns))

  aws_account_id                 = var.aws_account_id
  require_mfa_to_assume_role     = var.require_mfa_to_assume_roles
  allow_access_from_account_arns = var.allow_full_access_from_account_arns
}

resource "aws_iam_role" "allow_full_access_from_accounts" {
  count                = signum(length(var.allow_full_access_from_account_arns))
  name                 = var.full_access_iam_role_name
  assume_role_policy   = module.full_access_policies[count.index].allow_access_from_accounts_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy" "allow_full_access_from_accounts" {
  count  = signum(length(var.allow_full_access_from_account_arns))
  name   = "allow-full-access_from_accounts"
  role   = aws_iam_role.allow_full_access_from_accounts[count.index].id
  policy = module.full_access_policies[count.index].full_access_policy
}

module "billing_access_policies" {
  source = "../iam-policies"
  count  = length(var.allow_billing_access_from_account_arns) > 0 ? 1 : 0

  aws_account_id                 = var.aws_account_id
  require_mfa_to_assume_role     = var.require_mfa_to_assume_roles
  allow_access_from_account_arns = var.allow_billing_access_from_account_arns
}

resource "aws_iam_role" "allow_billing_access_from_accounts" {
  count                = signum(length(var.allow_billing_access_from_account_arns))
  name                 = var.billing_access_iam_role_name
  assume_role_policy   = module.billing_access_policies[count.index].allow_access_from_accounts_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy" "allow_billing_access_from_accounts" {
  count  = signum(length(var.allow_billing_access_from_account_arns))
  name   = "allow-billing-access_from_accounts"
  role   = aws_iam_role.allow_billing_access_from_accounts[count.index].id
  policy = module.billing_access_policies[count.index].billing_access_policy
}

module "dev_access_policies" {
  source = "../iam-policies"
  count  = length(var.allow_dev_access_from_account_arns) > 0 ? 1 : 0

  aws_account_id                 = var.aws_account_id
  require_mfa_to_assume_role     = var.require_mfa_to_assume_roles
  allow_access_from_account_arns = var.allow_dev_access_from_account_arns
  dev_services                   = var.dev_services
}

resource "aws_iam_role" "allow_dev_access_from_accounts" {
  count                = signum(length(var.allow_dev_access_from_account_arns))
  name                 = var.dev_access_iam_role_name
  assume_role_policy   = module.dev_access_policies[count.index].allow_access_from_accounts_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy" "allow_dev_access_from_accounts" {
  count  = signum(length(var.allow_dev_access_from_account_arns))
  name   = "allow-dev-access_from_accounts"
  role   = aws_iam_role.allow_dev_access_from_accounts[count.index].id
  policy = module.dev_access_policies[count.index].dev_access_policy
}

module "read_only_access_policies" {
  source = "../iam-policies"
  count  = length(var.allow_read_only_access_from_account_arns) > 0 ? 1 : 0

  aws_account_id                 = var.aws_account_id
  require_mfa_to_assume_role     = var.require_mfa_to_assume_roles
  allow_access_from_account_arns = var.allow_read_only_access_from_account_arns
}

resource "aws_iam_role" "allow_read_only_access_from_accounts" {
  count                = signum(length(var.allow_read_only_access_from_account_arns))
  name                 = var.read_only_access_iam_role_name
  assume_role_policy   = module.read_only_access_policies[count.index].allow_access_from_accounts_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy_attachment" "allow_read_only_access_from_accounts" {
  count      = signum(length(var.allow_read_only_access_from_account_arns))
  role       = aws_iam_role.allow_read_only_access_from_accounts[count.index].id
  policy_arn = module.read_only_access_policies[count.index].read_only_access_policy_arn
}

