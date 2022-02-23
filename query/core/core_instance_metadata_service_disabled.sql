select
  type || ' ' || name as resource,
  case
    when (arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'instance_options' ->> 'are_legacy_imds_endpoints_disabled')::boolean
    then ' legacy metadata service endpoint disabled'
    else ' legacy metadata service endpoint enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_instance';