output "full_access_policy" {
  value = data.aws_iam_policy_document.full_access.json
}
output "billing_access_policy" {
  value = data.aws_iam_policy_document.billing_access.json
}
output "dev_access_policy" {
  value = data.aws_iam_policy_document.dev_access.json
}
output "read_only_access_policy_arn" {
  value = data.aws_iam_policy.read_only_access.arn
}
output "allow_access_from_accounts_policy" {
  value = data.aws_iam_policy_document.allow_access_from_accounts.json
}
output "allow_access_to_accounts_policies" {
  value = data.aws_iam_policy_document.allow_access_to_accounts.*.json
}
output "iam_self_mgmt_policy" {
  value = data.aws_iam_policy_document.iam_self_mgmt.json
}
