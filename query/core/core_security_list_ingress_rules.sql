select
  type || ' ' || name as resource,
  case
    when (arguments -> 'ingress_security_rules' -> 'protocol') is not null
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'ingress_security_rules' -> 'protocol') is not null
    then ' has an inbound security list'
    else ' does not have an inbound security list'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_security_list';