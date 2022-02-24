locals {
  identity_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "identity"
  })
}

benchmark "identity" {
  title       = "Identity and Access Management"
  description = "This benchmark provides a set of controls that detect Terraform OCI Identity and Access Management resources deviating from security best practices."

  children = [
    control.identity_authentication_password_policy_strong_min_length_14
  ]

  tags = local.identity_compliance_common_tags
}

control "identity_authentication_password_policy_strong_min_length_14" {
  title       = "Ensure IAM password policy requires minimum length of 14 or greater"
  description = "Password policies are used to enforce password complexity requirements. IAM password policies can be used to ensure passwords are of at least a certain length and are composed of certain characters. It is recommended the password policy require a minimum password length of 14 characters and contain 1 non-alphabetic character (Number or 'Special Character')."
  sql           = query.identity_authentication_password_policy_strong_min_length_14.sql

  tags = merge(local.identity_compliance_common_tags, {
    cis         = true
  })
}