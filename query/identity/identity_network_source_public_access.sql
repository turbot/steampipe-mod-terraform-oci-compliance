select
  type || ' ' || name as resource,
  case
    when (arguments -> 'public_source_list') is not null and
      jsonb_array_length((arguments -> 'public_source_list')) > 0
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'public_source_list') is not null and
      jsonb_array_length((arguments -> 'public_source_list')) > 0
    then ' is publicly accessible'
    else ' is not publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_identity_network_source';