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
        attributes_std ->> 'network_security_group_id' as nsg_id,
        count(*) as count
      from
        all_sg_security_rule
      where
        attributes_std ->> 'direction' = 'INGRESS'
        and attributes_std ->> 'source_type' = 'CIDR_BLOCK'
        and attributes_std ->> 'source' = '0.0.0.0/0'
        and (
          attributes_std ->> 'protocol' = 'all'
          or (
            (attributes_std -> 'tcp_options' -> 'destination_port_range' ->> 'min')::integer <= 3389
            and (attributes_std -> 'tcp_options' -> 'destination_port_range' ->> 'max')::integer >= 3389
          )
        )
      group by nsg_id
    )
    select
      a.address as resource,
      case
        when (split_part(b.nsg_id , '.', 2)) is null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (split_part(b.nsg_id , '.', 2))  is null then ' ingress restricted for port 3389 from 0.0.0.0/0'
        else ' ingress rule(s) allowing port 3389 from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_sg as a
      left join non_complaint as b on a.name = (split_part(b.nsg_id , '.', 2));
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
        attributes_std ->> 'network_security_group_id' as nsg_id,
        count(*) as count
      from
        all_sg_security_rule
      where
        attributes_std ->> 'direction' = 'INGRESS'
        and attributes_std ->> 'source_type' = 'CIDR_BLOCK'
        and attributes_std ->> 'source' = '0.0.0.0/0'
        and (
          attributes_std ->> 'protocol' = 'all'
          or (
            (attributes_std -> 'tcp_options' -> 'destination_port_range' ->> 'min')::integer <= 22
            and (attributes_std -> 'tcp_options' -> 'destination_port_range' ->> 'max')::integer >= 22
          )
        )
      group by nsg_id
    )
    select
      a.address as resource,
      case
        when (split_part(b.nsg_id , '.', 2)) is null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (split_part(b.nsg_id , '.', 2))  is null then ' ingress restricted for SSH from 0.0.0.0/0'
        else ' ingress rule(s) allowing SSH from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_sg as a
      left join non_complaint as b on a.name = (split_part(b.nsg_id , '.', 2));
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
        case jsonb_typeof(attributes_std -> 'ingress_security_rules')
          when 'array' then (attributes_std -> 'ingress_security_rules')
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
      a.address as resource,
      case
        when b.count > 0 or
          ((a.attributes_std -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 22
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 22
            )
          ))
        then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when b.count > 0  or
          ((a.attributes_std -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 22
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 22
            )
          ))
          then ' ingress rule(s) allowing SSH from 0.0.0.0/0'
        else ' ingress restricted for SSH from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_list as a
      left join non_complaint as b on a.name = b.name;
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
        case jsonb_typeof(attributes_std -> 'ingress_security_rules')
            when 'array' then (attributes_std -> 'ingress_security_rules')
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
      a.address as resource,
      case
        when (b.count > 0) or
          ((a.attributes_std -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 3389
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
            )
          ))
          then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when b.count > 0 or
          ((a.attributes_std -> 'ingress_security_rules' ->> 'source' = '0.0.0.0/0' )
          and (
            (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = 'all')
            or ((a.attributes_std -> 'ingress_security_rules' ->> 'protocol' = '6')
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' is null))
            or ((a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'min') ::integer <= 3389
              and (a.attributes_std -> 'ingress_security_rules' -> 'tcp_options' ->> 'max')::integer >= 3389
            )
          ))
          then ' ingress rule(s) allowing port 3389 from 0.0.0.0/0'
        else ' ingress restricted for port 3389 from 0.0.0.0/0'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_list as a
      left join non_complaint as b on a.name = b.name;
  EOQ
}

query "vcn_subnet_public_access_blocked" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((attributes_std ->> 'prohibit_public_ip_on_vnic') is not null and
          (attributes_std ->> 'prohibit_public_ip_on_vnic')::boolean)
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((attributes_std ->> 'prohibit_public_ip_on_vnic') is not null and
          (attributes_std ->> 'prohibit_public_ip_on_vnic')::boolean)
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
        case jsonb_typeof(attributes_std -> 'ingress_security_rules')
            when 'array' then (attributes_std -> 'ingress_security_rules')
            else null end
        ) as p
      where
        p ->> 'protocol' != '1'
        group by name
    )
    select
      a.address as resource,
      case
        when b.count > 0 or (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' != '1') then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when b.count > 0 or (a.attributes_std -> 'ingress_security_rules' ->> 'protocol' != '1') then ' configured with non ICMP ports'
        else ' configured with ICMP ports only'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_rules as a
      left join non_complaint as b on a.name = b.name;
  EOQ
}

query "vcn_has_inbound_security_list_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'ingress_security_rules' ->> 'protocol') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ingress_security_rules' ->> 'protocol') is not null then ' has inbound security list configured'
        else ' has no inbound security list configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_security_list';
  EOQ
}

query "vcn_security_group_has_stateless_ingress_security_rules" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'direction' = 'INGRESS') and (attributes_std ->> 'stateless' is null or (attributes_std ->> 'stateless')::bool is not true) then 'alarm'
        when (attributes_std ->> 'direction' is null) or (attributes_std ->> 'direction' <> 'INGRESS') then 'info'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'direction' = 'INGRESS') and (attributes_std ->> 'stateless' is null or (attributes_std ->> 'stateless')::bool is not true) then ' does not have stateless ingress security rules'
        when (attributes_std ->> 'direction' is null) or (attributes_std ->> 'direction' <> 'INGRESS') then ' has no ingress security rules'
        else ' has stateless ingress security rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'oci_core_network_security_group_security_rule';
  EOQ
}

query "vcn_inbound_security_lists_are_stateless" {
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
        case jsonb_typeof(attributes_std -> 'ingress_security_rules')
            when 'array' then (attributes_std -> 'ingress_security_rules')
            else null end
        ) as p
      where
        p ->> 'stateless' is not null and (p ->> 'stateless')::bool is not true
        group by name
    )
    select
      a.address as resource,
      case
        when b.count > 0 or (a.attributes_std -> 'ingress_security_rules' ->> 'stateless' is not null and (a.attributes_std -> 'ingress_security_rules' ->> 'stateless')::bool is not true) then 'alarm'
        when (a.attributes_std ->> 'ingress_security_rules' is null) then 'skip'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when b.count > 0 or (a.attributes_std -> 'ingress_security_rules' ->> 'stateless' is not null and (a.attributes_std -> 'ingress_security_rules' ->> 'stateless')::bool is not true) then ' has stateful ingress security rules'
        when (a.attributes_std ->> 'ingress_security_rules' is null) then ' has no ingress security rules'
        else ' has stateless ingress security rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_security_rules as a
      left join non_complaint as b on a.name = b.name;
  EOQ
}
