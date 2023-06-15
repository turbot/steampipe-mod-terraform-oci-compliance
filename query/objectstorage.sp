query "objectstorage_bucket_encryption_enabled" {
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
      type = 'oci_objectstorage_bucket';
  EOQ
}

query "objectstorage_bucket_public_access_blocked" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
        then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
        then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_objectstorage_bucket';
  EOQ
}

query "objectstorage_bucket_versioning_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'versioning') = 'Enabled'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'versioning') = 'Enabled'
        then ' has versioning enabled'
        else ' has versioning disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_objectstorage_bucket';
  EOQ
}
