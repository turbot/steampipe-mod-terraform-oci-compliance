locals {
  core_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "core"
  })
}

benchmark "core" {
  title       = "Core Services"
  description = "This benchmark provides a set of controls that detect Terraform OCI Core resources deviating from security best practices."

  children = [
    control.core_boot_volume_encryption_enabled,
    control.core_default_security_group_allow_icmp_only,
    control.core_network_security_list_restrict_ingress_rdp_all,
    control.core_network_security_list_restrict_ingress_ssh_all,
    control.core_volume_encryption_enabled
  ]

  tags = local.core_compliance_common_tags
}

control "core_boot_volume_encryption_enabled" {
  title       = "Core boot volume encryption should be enabled"
  description = "Ensure core boot volume is encrypted at rest to protect sensitive data."
  sql           = query.core_boot_volume_encryption_enabled.sql

  tags = local.core_compliance_common_tags

}

control "core_default_security_group_allow_icmp_only" {
  title       = "Ensure the default security list of every VCN restricts all traffic except ICMP"
  description = "A default security list is created when a Virtual Cloud Network (VCN) is created. Security lists provide stateful filtering of ingress and egress network traffic to OCI resources. It is recommended no security list allows unrestricted ingress access to Secure Shell (SSH) via port 22."
  sql           = query.core_default_security_group_allow_icmp_only.sql

  tags = merge(local.core_compliance_common_tags, {
    cis         = true
  })
}

control "core_network_security_list_restrict_ingress_rdp_all" {
  title       = "Ensure no network security groups allow ingress from 0.0.0.0/0 to port 3389"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  sql           = query.core_network_security_list_restrict_ingress_rdp_all.sql

  tags = merge(local.core_compliance_common_tags, {
    cis         = true
  })
}

control "core_network_security_list_restrict_ingress_ssh_all" {
  title       = "Ensure no network security groups allow ingress from 0.0.0.0/0 to port 22"
  description = "Network security groups provide stateful filtering of ingress/egress network traffic to OCI resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  sql           = query.core_network_security_list_restrict_ingress_ssh_all.sql

  tags = merge(local.core_compliance_common_tags, {
    cis         = true
  })
}

control "core_volume_encryption_enabled" {
  title       = "Core volume encryption should be enabled"
  description = "Ensure core volume is encrypted at rest to protect sensitive data."
  sql           = query.core_volume_encryption_enabled.sql

  tags = local.core_compliance_common_tags
}