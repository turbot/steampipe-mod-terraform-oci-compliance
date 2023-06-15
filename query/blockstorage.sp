query "blockstorage_boot_volume_backup_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'source_details') is null then 'alarm'
        when (arguments -> 'source_details' -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'source_details') is null then ' encryption disabled'
        when (arguments -> 'source_details' -> 'kms_key_id') is null then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_boot_volume_backup';
  EOQ
}

query "blockstorage_block_volume_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
      when (arguments ->> 'kms_key_id') is null then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_volume';
  EOQ
}

query "blockstorage_boot_volume_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'kms_key_id') is null then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_boot_volume';
  EOQ
}
