locals {
  identity_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/Identity"
  })
}

benchmark "identity" {
  title       = "Identity and Access Management"
  description = "This benchmark provides a set of controls that detect Terraform OCI Identity and Access Management resources deviating from security best practices."

  children = [
    control.identity_authentication_password_policy_contains_lowercase_characters,
    control.identity_authentication_password_policy_contains_numeric_characters,
    control.identity_authentication_password_policy_contains_special_characters,
    control.identity_authentication_password_policy_contains_uppercase_characters,
    control.identity_authentication_password_policy_strong_min_length_14
  ]

  tags = merge(local.identity_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "identity_authentication_password_policy_strong_min_length_14" {
  title       = "Ensure IAM password policy requires minimum length of 14 or greater"
  description = "Password policies are used to enforce password complexity requirements. IAM password policies can be used to ensure passwords are of at least a certain length and are composed of certain characters. It is recommended the password policy require a minimum password length of 14 characters and contain 1 non-alphabetic character (Number or 'Special Character')."
  query       = query.identity_authentication_password_policy_strong_min_length_14

  tags = merge(local.identity_compliance_common_tags, {
    cis = true
  })
}

control "identity_authentication_password_policy_contains_lowercase_characters" {
  title       = "IAM password policy should contain at least one lowercase character"
  description = "This control checks whether the IAM password policy contains at least one lowercase character."
  query       = query.identity_authentication_password_policy_contains_lowercase_characters

  tags = local.identity_compliance_common_tags
}

control "identity_authentication_password_policy_contains_uppercase_characters" {
  title       = "IAM password policy should contain at least one uppercase character"
  description = "This control checks whether the IAM password policy contains at least one uppercase character."
  query       = query.identity_authentication_password_policy_contains_uppercase_characters

  tags = local.identity_compliance_common_tags
}

control "identity_authentication_password_policy_contains_numeric_characters" {
  title       = "IAM password policy should contain at least one numeric character"
  description = "This control checks whether the IAM password policy contains at least one numeric character."
  query       = query.identity_authentication_password_policy_contains_numeric_characters

  tags = local.identity_compliance_common_tags
}

control "identity_authentication_password_policy_contains_special_characters" {
  title       = "IAM password policy should contain at least one special character"
  description = "This control checks whether the IAM password policy contains at least one special character."
  query       = query.identity_authentication_password_policy_contains_special_characters

  tags = local.identity_compliance_common_tags
}