select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'is_pv_encryption_in_transit_enabled')::boolean
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'is_pv_encryption_in_transit_enabled')::boolean
    then ' in-transit data encryption enabled'
    else ' in-transit data encryption disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_instance';