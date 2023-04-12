query "database_db_home_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_database_db_home';
  EOQ
}

query "database_db_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_database_database';
  EOQ
}

query "database_db_system_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce((arguments ->> 'kms_key_id'), '') = '' then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_database_db_system';
  EOQ
}
