select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'access_type') like 'Object%' then 'alarm'
    else 'ok'
  end as status,
   name || case
    when (arguments ->> 'access_type') like 'Object%' then ' publicly accessible'
    else ' not publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket'
