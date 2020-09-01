variable "aws_account_id" {
  type = string
}

variable "require_mfa_to_assume_roles" {
  default = true
}

variable "max_session_duration" {
  default = 43200
}

variable "allow_full_access_from_account_arns" {
  type    = list(string)
  default = []
}

variable "full_access_iam_role_name" {
  type    = string
  default = "cross_account_full_access"
}

variable "allow_billing_access_from_account_arns" {
  type    = list(string)
  default = []
}

variable "billing_access_iam_role_name" {
  type    = string
  default = "cross_account_billing_access"
}

variable "allow_dev_access_from_account_arns" {
  type    = list(string)
  default = []
}

variable "dev_access_iam_role_name" {
  type    = string
  default = "cross_account_dev_access"
}

variable "allow_read_only_access_from_account_arns" {
  type    = list(string)
  default = []
}

variable "read_only_access_iam_role_name" {
  type    = string
  default = "cross_account_read_only_access"
}

variable "dev_services" {
  type    = list(string)
  default = []
}

