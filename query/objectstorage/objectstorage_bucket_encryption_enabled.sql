select
  type || ' ' || name as resource,
  case
    when coalesce((arguments ->> 'kms_key_id'), '') = '' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce((arguments ->> 'kms_key_id'), '') = '' then ' encryption disabled'
    else ' encryption enabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'oci_objectstorage_bucket';