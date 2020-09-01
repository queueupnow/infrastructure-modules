variable "aws_account_id" {
  type = string
}
variable "require_mfa_to_assume_role" {
  default = true
}
variable "require_mfa_iam_self_mgmt" {
  default = true
}
variable "allow_access_from_account_arns" {
  type    = list(string)
  default = []
}
variable "allow_access_to_account_arns" {
  type    = list(list(string))
  default = []
}
variable "dev_services" {
  type    = list(string)
  default = []
}
