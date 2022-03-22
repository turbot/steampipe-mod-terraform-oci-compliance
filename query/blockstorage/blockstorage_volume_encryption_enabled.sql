select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'kms_key_id') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
   when (arguments ->> 'kms_key_id') is null then ' encryption disabled'
    else ' encryption enabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'oci_core_volume';