select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments ->> 'access_type') in ('ObjectRead', 'ObjectReadWithoutList')
    then ' is publicly accessible'
    else ' is not publicly accessible'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket';
