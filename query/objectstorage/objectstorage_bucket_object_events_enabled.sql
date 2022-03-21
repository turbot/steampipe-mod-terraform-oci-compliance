select
  type || ' ' || name as resource,
  case
    when ((arguments ->> 'object_events_enabled') is not null and
      (arguments ->> 'object_events_enabled')::boolean)
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when ((arguments ->> 'object_events_enabled') is not null and
      (arguments ->> 'object_events_enabled')::boolean)
    then ' can emit object events'
    else ' cannot emit object events'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket';