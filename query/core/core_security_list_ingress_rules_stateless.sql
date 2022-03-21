select
  type || ' ' || name as resource,
  case
    when ((arguments -> 'ingress_security_rules' ->> 'stateless') is not null and
      (arguments -> 'ingress_security_rules' ->> 'stateless')::boolean)
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when ((arguments -> 'ingress_security_rules' ->> 'stateless') is not null and
      (arguments -> 'ingress_security_rules' ->> 'stateless')::boolean)
    then ' ingress rules are stateless'
    else ' ingress rules are not stateless'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_security_list';