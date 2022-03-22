locals {
  network_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "network"
  })
}

benchmark "network" {
  title       = "Network"
  description = "This benchmark provides a set of controls that detect Terraform OCI Network resources deviating from security best practices."

  children = [
    control.network_default_security_group_allow_icmp_only,
    control.network_security_list_restrict_ingress_rdp_all,
    control.network_security_list_restrict_ingress_ssh_all,
    control.network_subnet_public_access_blocked
  ]

  tags = local.network_compliance_common_tags
}

control "network_subnet_public_access_blocked" {
  title       = "Ensure subnetworks are not publicly accessible"
  description = "Public access to a network's subnetwork increases resource attack surface and unnecessarily raises the risk of resource compromise. A network source is a set of defined IP addresses. The IP addresses can be public IP addresses or IP addresses from VCNs within your tenancy. After you create a network source, you can reference it in policy or in your tenancy's authentication settings to control access based on the originating IP address."
  sql           = query.network_subnet_public_access_blocked.sql

  tags = local.network_compliance_common_tags

}

control "network_default_security_group_allow_icmp_only" {
  title       = "Ensure the default security list of every VCN restricts all traffic except ICMP"
  description = "A default security list is created when a Virtual Cloud Network (VCN) is created. Security lists provide stateful filtering of ingress and egress network traffic to OCI resources. It is recommended no security list allows unrestricted ingress access to Secure Shell (SSH) via port 22."
  sql           = query.network_default_security_group_allow_icmp_only.sql

  tags = merge(local.network_compliance_common_tags, {
    cis         = true
  })
}

control "network_security_list_restrict_ingress_rdp_all" {
  title       = "Ensure no network security groups allow ingress from 0.0.0.0/0 to port 3389"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  sql           = query.network_security_list_restrict_ingress_rdp_all.sql

  tags = merge(local.network_compliance_common_tags, {
    cis         = true
  })
}

control "network_security_list_restrict_ingress_ssh_all" {
  title       = "Ensure no network security groups allow ingress from 0.0.0.0/0 to port 22"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  sql           = query.network_security_list_restrict_ingress_ssh_all.sql

  tags = merge(local.network_compliance_common_tags, {
    cis         = true
  })
}

