select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'status') = 'ENABLED' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when coalesce((arguments ->> 'status'), '') = '' then ' ''status'' is not defined'
    when (arguments ->> 'status') = 'ENABLED' then ' CloudGuard enabled'
    else ' CloudGuard disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_cloud_guard_cloud_guard_configuration';