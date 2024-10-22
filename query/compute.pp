query "compute_instance_monitoring_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'agent_config' -> 'is_monitoring_disabled') is null or
          not (attributes_std -> 'agent_config' -> 'is_monitoring_disabled')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((attributes_std -> 'agent_config' -> 'is_monitoring_disabled') is null or
          not (attributes_std -> 'agent_config' -> 'is_monitoring_disabled')::boolean)
        then ' has monitoring enabled'
        else ' has monitoring disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_instance';
  EOQ
}

query "compute_instance_metadata_service_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled') is not null and
          (attributes_std -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled') is not null and
          (attributes_std -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean)
        then ' legacy metadata service endpoint disabled'
        else ' legacy metadata service endpoint enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_instance';
  EOQ
}

query "compute_instance_boot_volume_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'launch_options' -> 'is_pv_encryption_in_transit_enabled') is not null and
          (attributes_std -> 'launch_options' ->> 'is_pv_encryption_in_transit_enabled')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((attributes_std -> 'launch_options' -> 'is_pv_encryption_in_transit_enabled') is not null and
          (attributes_std -> 'launch_options' ->> 'is_pv_encryption_in_transit_enabled')::boolean)
        then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_instance';
  EOQ
}