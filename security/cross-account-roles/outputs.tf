output "full_access_role_id" {
  value = length(var.allow_full_access_from_account_arns) > 0 ? aws_iam_role.allow_full_access_from_accounts[0].id : ""
}
output "full_access_role_arn" {
  value = length(var.allow_full_access_from_account_arns) > 0 ? aws_iam_role.allow_full_access_from_accounts[0].arn : ""
}
output "billing_access_role_id" {
  value = length(var.allow_billing_access_from_account_arns) > 0 ? aws_iam_role.allow_billing_access_from_accounts[0].id : ""
}
output "billing_access_role_arn" {
  value = length(var.allow_billing_access_from_account_arns) > 0 ? aws_iam_role.allow_billing_access_from_accounts[0].arn : ""
}
output "dev_access_role_id" {
  value = length(var.allow_dev_access_from_account_arns) > 0 ? aws_iam_role.allow_dev_access_from_accounts[0].id : ""
}
output "dev_access_role_arn" {
  value = length(var.allow_dev_access_from_account_arns) > 0 ? aws_iam_role.allow_dev_access_from_accounts[0].arn : ""
}
output "read_only_access_role_id" {
  value = length(var.allow_read_only_access_from_account_arns) > 0 ? aws_iam_role.allow_read_only_access_from_accounts[0].id : ""
}
output "read_only_access_role_arn" {
  value = length(var.allow_read_only_access_from_account_arns) > 0 ? aws_iam_role.allow_read_only_access_from_accounts[0].arn : ""
}
