locals {
  compute_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/Compute"
  })
}

benchmark "compute" {
  title       = "Compute"
  description = "This benchmark provides a set of controls that detect Terraform OCI Compute resources deviating from security best practices."

  children = [
    control.compute_instance_metadata_service_disabled,
    control.compute_instance_monitoring_enabled
  ]

  tags = merge(local.compute_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "compute_instance_metadata_service_disabled" {
  title       = "Compute instance legacy metadata service endpoint should be disabled"
  description = "The instance metadata service (IMDS) provides information about a running instance, including a variety of details about the instance, its attached virtual network interface cards (VNICs), its attached multipath-enabled volume attachments, and any custom metadata that you define. IMDS also provides information to cloud-init that you can use for various system initialization tasks. To increase the security of metadata requests, it is strongly recommended to update all applications to use the IMDS version 2 endpoint, if supported by the image. Then, disable requests to IMDS version 1."
  query       = query.compute_instance_metadata_service_disabled

  tags = local.compute_compliance_common_tags

}

control "compute_instance_monitoring_enabled" {
  title       = "Compute instance monitoring should be enabled"
  description = "Oracle Cloud Infrastructure Monitoring helps organizations optimize the resource utilization and uptime of their infrastructure and applications. This service provides fine-grained, out-of-the-box metrics and dashboards that equip DevOps, IT, and site reliability engineers (SREs) with the real-time insights to respond to anomalies as they occur. The Monitoring capabilities are concerning Service Metrics, Metrics Explorer, Alarm Status and Definition and Health Checks."
  query       = query.compute_instance_monitoring_enabled

  tags = local.compute_compliance_common_tags

}

