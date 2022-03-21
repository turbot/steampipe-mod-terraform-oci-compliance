select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'versioning') = 'Enabled'
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'versioning') = 'Enabled'
    then ' has versioning enabled'
    else ' has versioning disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket';