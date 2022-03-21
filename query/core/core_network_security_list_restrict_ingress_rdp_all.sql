with all_sg_security_rule as (
  select
    *
  from
    terraform_resource
  where
    type = 'oci_core_network_security_group_security_rule'
), all_sg as (
  select
    *
  from
    terraform_resource
  where
    type = 'oci_core_network_security_group'
), non_complaint as (
  select
    arguments ->> 'network_security_group_id' as nsg_id,
    count(*) as count
  from
    all_sg_security_rule
  where
    arguments ->> 'direction' = 'INGRESS'
    and arguments ->> 'source_type' = 'CIDR_BLOCK'
    and arguments ->> 'source' = '0.0.0.0/0'
    and (
      arguments ->> 'protocol' = 'all'
      or (
        (arguments -> 'tcp_options' -> 'destination_port_range' ->> 'min')::integer <= 3389
        and (arguments -> 'tcp_options' -> 'destination_port_range' ->> 'max')::integer >= 3389
      )
    )
 group by nsg_id
)
select
  a.type || ' ' || a.name as resource,
  case
    when (split_part(b.nsg_id , '.', 2)) is null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (split_part(b.nsg_id , '.', 2))  is null then ' ingress restricted for port 3389 from 0.0.0.0/0'
    else ' ingress rule(s) allowing port 3389 from 0.0.0.0/0'
  end || '.' reason,
  path || ':' || start_line
from
  all_sg as a left join non_complaint as b on a.name = (split_part(b.nsg_id , '.', 2))
