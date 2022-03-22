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
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'oci_core_instance';