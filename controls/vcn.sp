locals {
  vcn_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/VCN"
  })
}

benchmark "vcn" {
  title       = "VCN"
  description = "This benchmark provides a set of controls that detect Terraform OCI Network resources deviating from security best practices."

  children = [
    control.vcn_default_security_group_allow_icmp_only,
    control.vcn_network_security_group_restrict_ingress_rdp_all,
    control.vcn_network_security_group_restrict_ingress_ssh_all,
    control.vcn_security_list_restrict_ingress_rdp_all,
    control.vcn_security_list_restrict_ingress_ssh_all,
    control.vcn_subnet_public_access_blocked
  ]

  tags = local.vcn_compliance_common_tags
}

control "vcn_default_security_group_allow_icmp_only" {
  title       = "Ensure the Network default security list of every VCN restricts all traffic except ICMP"
  description = "A default security list is created when a Virtual Cloud Network (VCN) is created. Security lists provide stateful filtering of ingress and egress network traffic to OCI resources. It is recommended no security list allows unrestricted ingress access to Secure Shell (SSH) via port 22."
  query       = query.vcn_default_security_group_allow_icmp_only

  tags = merge(local.vcn_compliance_common_tags, {
    cis = true
  })
}

control "vcn_network_security_group_restrict_ingress_rdp_all" {
  title       = "Ensure no Network security groups allow ingress from 0.0.0.0/0 to port 3389"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query       = query.vcn_network_security_group_restrict_ingress_rdp_all

  tags = merge(local.vcn_compliance_common_tags, {
    cis = true
  })
}

control "vcn_network_security_group_restrict_ingress_ssh_all" {
  title       = "Ensure no Network security groups allow ingress from 0.0.0.0/0 to port 22"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  query       = query.vcn_network_security_group_restrict_ingress_ssh_all

  tags = merge(local.vcn_compliance_common_tags, {
    cis = true
  })
}

control "vcn_security_list_restrict_ingress_rdp_all" {
  title       = "Ensure no security lists allow ingress from 0.0.0.0/0 to port 3389"
  description = "Security lists provide stateful or stateless filtering of ingress/egress network traffic to OCI resources on a subnet level. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query       = query.vcn_security_list_restrict_ingress_rdp_all

  tags = merge(local.vcn_compliance_common_tags, {
    cis = true
  })
}

control "vcn_security_list_restrict_ingress_ssh_all" {
  title       = "Ensure no security lists allow ingress from 0.0.0.0/0 to port 22"
  description = "Security lists provide stateful or stateless filtering of ingress/egress network traffic to OCI resources on a subnet level. It is recommended that no security group allows unrestricted ingress access to port 22."
  query       = query.vcn_security_list_restrict_ingress_ssh_all

  tags = merge(local.vcn_compliance_common_tags, {
    cis = true
  })
}

control "vcn_subnet_public_access_blocked" {
  title       = "Ensure subnets are not publicly accessible"
  description = "Public access to a Network's subnet increases resource attack surface and unnecessarily raises the risk of resource compromise. A network source is a set of defined IP addresses. The IP addresses can be public IP addresses or IP addresses from VCNs within your tenancy. After you create a network source, you can reference it in policy or in your tenancy's authentication settings to control access based on the originating IP address."
  query       = query.vcn_subnet_public_access_blocked

  tags = local.vcn_compliance_common_tags

}