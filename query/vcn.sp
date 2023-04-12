query "vcn_network_security_group_restrict_ingress_rdp_all" {
  sql = <<-EOQ
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
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_sg as a left join non_complaint as b on a.name = (split_part(b.nsg_id , '.', 2))
  EOQ
}

query "vcn_network_security_group_restrict_ingress_ssh_all" {
  sql = <<-EOQ
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
            (arguments -> 'tcp_options' -> 'destination_port_range' ->> 'min')::integer <= 22
            and (arguments -> 'tcp_options' -> 'destination_port_range' ->> 'max')::integer >= 22
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
        when (split_part(b.nsg_id , '.', 2))  is null then ' ingress restricted for SSH from 0.0.0.0/0'
        else ' ingress rule(s) allowing SSH from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_sg as a left join non_complaint as b on a.name = (split_part(b.nsg_id , '.', 2))
  EOQ
}

query "vcn_security_list_restrict_ingress_ssh_all" {
  sql = <<-EOQ
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
            p ->> 'protocol' = '6'
            and (p -> 'tcp_options' ->> 'min')::integer <= 22
            and (p -> 'tcp_options' ->> 'max')::integer >= 22
          )
        )
      group by
      name
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when b.count > 0 or
          ((a.arguments -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.arguments -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.arguments -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 22
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 22
            )
          ))
        then 'alarm'
        else 'ok'
      end as status,
      a.name || case
        when b.count > 0  or
          ((a.arguments -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.arguments -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.arguments -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 22
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 22
            )
          ))
          then ' ingress rule(s) allowing SSH from 0.0.0.0/0'
        else ' ingress restricted for SSH from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_list as a left join non_complaint as b on a.name = b.name
  EOQ
}

query "vcn_security_list_restrict_ingress_rdp_all" {
  sql = <<-EOQ
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
            p ->> 'protocol' = '6'
            and (p -> 'tcp_options' ->> 'min')::integer <= 3389
            and (p -> 'tcp_options' ->> 'max')::integer >= 3389
          )
        )
      group by
      name
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (b.count > 0) or
          ((a.arguments -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.arguments -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.arguments -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 3389
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
            )
          ))
          then 'alarm'
        else 'ok'
      end as status,
      a.name || case
        when b.count > 0 or
          ((a.arguments -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.arguments -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.arguments -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 3389
              and (a.arguments -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
            )
          ))
          then ' ingress rule(s) allowing port 3389 from 0.0.0.0/0'
        else ' ingress restricted for port 3389 from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_list as a left join non_complaint as b on a.name = b.name
  EOQ
}

query "vcn_subnet_public_access_blocked" {
  sql = <<-EOQ
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
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_subnet';
  EOQ
}

query "vcn_default_security_group_allow_icmp_only" {
  sql = <<-EOQ
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
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_rules as a left join non_complaint as b on a.name = b.name
  EOQ
}
