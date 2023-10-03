query "cloudguard_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'status') = 'ENABLED' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce((attributes_std ->> 'status'), '') = '' then ' ''status'' is not defined'
        when (attributes_std ->> 'status') = 'ENABLED' then ' CloudGuard enabled'
        else ' CloudGuard disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_cloud_guard_cloud_guard_configuration';
  EOQ
}
