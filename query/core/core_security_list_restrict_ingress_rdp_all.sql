select
  type || ' ' || name as resource,
  case
    when (arguments -> 'ingress_security_rules' ->> 'source') = '0.0.0.0/0'
      and (
        (
          (arguments -> 'ingress_security_rules' ->> 'protocol') = 'all'
          and (arguments -> 'ingress_security_rules' -> 'tcp_options' -> 'min') is null
        )
        or (
          (arguments -> 'ingress_security_rules' ->> 'protocol') = '6' and
          (arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min')::integer <= 3389
          and (arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
        )
      )
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'ingress_security_rules' ->> 'source') = '0.0.0.0/0'
      and (
        (
          (arguments -> 'ingress_security_rules' ->> 'protocol') = 'all'
          and (arguments -> 'ingress_security_rules' -> 'tcp_options' -> 'min') is null
        )
        or (
          (arguments -> 'ingress_security_rules' ->> 'protocol') = '6' and
          (arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min')::integer <= 3389
          and (arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
        )
      )
    then ' ingress rule(s) allowing port 3389 from 0.0.0.0/0'
    else ' ingress restricted for port 3389 from 0.0.0.0/0'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'oci_core_security_list';