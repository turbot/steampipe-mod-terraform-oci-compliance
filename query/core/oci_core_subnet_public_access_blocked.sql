select
  type || ' ' || name as resource,
  case
    when ((arguments ->> 'prohibit_public_ip_on_vnic') is not null and
      (arguments ->> 'prohibit_public_ip_on_vnic')::boolean)
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when ((arguments ->> 'prohibit_public_ip_on_vnic') is not null and
      (arguments ->> 'prohibit_public_ip_on_vnic')::boolean)
    then ' is not publicly accessible'
    else ' is publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_subnet';