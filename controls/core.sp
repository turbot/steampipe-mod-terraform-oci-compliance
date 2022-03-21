locals {
  core_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "core"
  })
}

benchmark "core" {
  title       = "Core Services"
  description = "This benchmark provides a set of controls that detect Terraform OCI Core resources deviating from security best practices."

  children = [
    control.core_boot_volume_attachment_encryption_enabled,
    control.core_boot_volume_encryption_enabled,
    control.core_default_security_group_allow_icmp_only,
    control.core_instance_metadata_service_disabled,
    control.core_instance_monitoring_enabled,
    control.core_network_security_list_restrict_ingress_rdp_all,
    control.core_network_security_list_restrict_ingress_ssh_all,
    control.core_volume_encryption_enabled,
    control.oci_core_subnet_public_access_blocked
  ]

  tags = local.core_compliance_common_tags
}

control "core_boot_volume_encryption_enabled" {
  title       = "Core boot volume encryption should be enabled"
  description = "Ensure core boot volume is encrypted at rest to protect sensitive data."
  sql           = query.core_boot_volume_encryption_enabled.sql

  tags = local.core_compliance_common_tags
}

control "oci_core_subnet_public_access_blocked" {
  title       = "Ensure core network's subnetworks are not publicly accessible"
  description = "Public access to a network's subnetwork increases resource attack surface and unnecessarily raises the risk of resource compromise. A network source is a set of defined IP addresses. The IP addresses can be public IP addresses or IP addresses from VCNs within your tenancy. After you create a network source, you can reference it in policy or in your tenancy's authentication settings to control access based on the originating IP address."
  sql           = query.oci_core_subnet_public_access_blocked.sql

  tags = local.core_compliance_common_tags

}

control "core_boot_volume_attachment_encryption_enabled" {
  title       = "Core boot volume attachment encryption should be enabled"
  description = "Ensure core boot volume attachments are encrypted at rest to protect sensitive data."
  sql           = query.core_boot_volume_attachment_encryption_enabled.sql

  tags = local.core_compliance_common_tags

}

control "core_instance_metadata_service_disabled" {
  title       = "Core Instance legacy metadata service endpoint should be disabled"
  description = "The instance metadata service (IMDS) provides information about a running instance, including a variety of details about the instance, its attached virtual network interface cards (VNICs), its attached multipath-enabled volume attachments, and any custom metadata that you define. IMDS also provides information to cloud-init that you can use for various system initialization tasks. To increase the security of metadata requests, it is strongly recommended to update all applications to use the IMDS version 2 endpoint, if supported by the image. Then, disable requests to IMDS version 1."
  sql           = query.core_instance_metadata_service_disabled.sql

  tags = local.core_compliance_common_tags

}

control "core_instance_monitoring_enabled" {
  title       = "Core Instance monitoring should be enabled"
  description = "Oracle Cloud Infrastructure Monitoring helps organizations optimize the resource utilization and uptime of their infrastructure and applications. This service provides fine-grained, out-of-the-box metrics and dashboards that equip DevOps, IT, and site reliability engineers (SREs) with the real-time insights to respond to anomalies as they occur. The Monitoring capabilities are concerning Service Metrics, Metrics Explorer, Alarm Status and Definition and Health Checks."
  sql           = query.core_instance_monitoring_enabled.sql

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