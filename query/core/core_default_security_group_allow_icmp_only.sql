with all_security_rules as (
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
    all_security_rules,
    jsonb_array_elements(
    case jsonb_typeof(arguments -> 'ingress_security_rules')
        when 'array' then (arguments -> 'ingress_security_rules')
        else null end
    ) as p
  where
    p ->> 'protocol' != '1'
    group by name
)
select
  a.type || ' ' || a.name as resource,
  case
    when b.count > 0 or (a.arguments -> 'ingress_security_rules' ->> 'protocol' != '1') then 'alarm'
    else 'ok'
  end as status,
   a.name || case
    when b.count > 0 or (a.arguments -> 'ingress_security_rules' ->> 'protocol' != '1') then ' configured with non ICMP ports'
    else ' configured with ICMP ports only'
  end || '.' reason,
  path
from
  all_security_rules as a left join non_complaint as b on a.name = b.name

