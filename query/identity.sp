query "identity_authentication_password_policy_strong_min_length_14" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'password_policy' ->> 'minimum_password_length') is not null and
          (attributes_std -> 'password_policy' ->> 'minimum_password_length')::integer >= 14 and
          ((attributes_std -> 'password_policy' ->> 'is_numeric_characters_required')::boolean or
          (attributes_std -> 'password_policy' ->> 'is_special_characters_required')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'password_policy' ->> 'minimum_password_length') is null
        then ' No password policy set'
        when (attributes_std -> 'password_policy' ->> 'minimum_password_length')::integer >= 14 and
          ((attributes_std -> 'password_policy' ->> 'is_numeric_characters_required')::boolean or
          (attributes_std -> 'password_policy' ->> 'is_special_characters_required')::boolean)
        then ' Strong password policies configured'
        else ' Strong password policies not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_identity_authentication_policy';
  EOQ
}

query "identity_authentication_password_policy_contains_lowercase_characters" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'password_policy' ->> 'is_lowercase_characters_required')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'password_policy' ->> 'is_lowercase_characters_required')::boolean then ' contains lowercase characters'
        else ' does not contain lowercase characters'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_identity_authentication_policy';
  EOQ
}

query "identity_authentication_password_policy_contains_uppercase_characters" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'password_policy' ->> 'is_uppercase_characters_required')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'password_policy' ->> 'is_uppercase_characters_required')::boolean then ' contains uppercase characters'
        else ' does not contain uppercase characters'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_identity_authentication_policy';
  EOQ
}

query "identity_authentication_password_policy_contains_numeric_characters" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'password_policy' ->> 'is_numeric_characters_required')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'password_policy' ->> 'is_numeric_characters_required')::boolean then ' contains numeric characters'
        else ' does not contain numeric characters'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_identity_authentication_policy';
  EOQ
}

query "identity_authentication_password_policy_contains_special_characters" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'password_policy' ->> 'is_special_characters_required')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'password_policy' ->> 'is_special_characters_required')::boolean then ' contains special characters'
        else ' does not contain special characters'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_identity_authentication_policy';
  EOQ
}