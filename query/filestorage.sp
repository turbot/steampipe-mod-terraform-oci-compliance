query "file_storage_file_system_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when coalesce((attributes_std ->> 'kms_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce((attributes_std ->> 'kms_key_id'), '') = '' then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_file_storage_file_system';
  EOQ
}
