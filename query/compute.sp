query "compute_instance_monitoring_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments -> 'agent_config' -> 'is_monitoring_disabled') is null or
          not (arguments -> 'agent_config' -> 'is_monitoring_disabled')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments -> 'agent_config' -> 'is_monitoring_disabled') is null or
          not (arguments -> 'agent_config' -> 'is_monitoring_disabled')::boolean)
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
      type || ' ' || name as resource,
      case
        when ((arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled') is not null and
          (arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled') is not null and
          (arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean)
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
