query "identity_authentication_password_policy_strong_min_length_14" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'password_policy' ->> 'minimum_password_length') is not null and
          (arguments -> 'password_policy' ->> 'minimum_password_length')::integer >= 14 and
          ((arguments -> 'password_policy' ->> 'is_numeric_characters_required')::boolean or
          (arguments -> 'password_policy' ->> 'is_special_characters_required')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'password_policy' ->> 'minimum_password_length') is null
        then ' No password policy set'
        when (arguments -> 'password_policy' ->> 'minimum_password_length')::integer >= 14 and
          ((arguments -> 'password_policy' ->> 'is_numeric_characters_required')::boolean or
          (arguments -> 'password_policy' ->> 'is_special_characters_required')::boolean)
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