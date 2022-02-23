select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
    then ' is public'
    else ' is not public'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket';