with all_security_list as (
  select
    *
  from
    terraform_resource
  where
    type = 'oci_core_security_list'
), non_complaint as (
  select
    name,
    count(name) as count
  from
    all_security_list,
    jsonb_array_elements(
    case jsonb_typeof(arguments -> 'ingress_security_rules')
        when 'array' then (arguments -> 'ingress_security_rules')
        else null end
    ) as p
  where
    p ->> 'source' = '0.0.0.0/0'
    and (
      p ->> 'protocol' = 'all'
      or (
        (p -> 'tcp_options' ->> 'min')::integer <= 3389
        and (p -> 'tcp_options' ->> 'max')::integer >= 3389
      )
    )
  group by
   name
)
select
  a.type || ' ' || a.name as resource,
  case
    when b.count > 0  then 'alarm'
    else 'ok'
  end as status,
   a.name || case
    when b.count > 0 or (a.arguments -> 'ingress_security_rules' ->> 'protocol' != '1') then ' configured with non ICMP ports'
    else ' configured with ICMP ports only'
  end || '.' reason,
  path || ':' || start_line
from
  all_security_list as a left join non_complaint as b on a.name = b.name