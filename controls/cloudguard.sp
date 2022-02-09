locals {
  cloudguard_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cloudguard"
  })
}

benchmark "cloudguard" {
  title       = "Cloud Guard"
  description = "This benchmark provides a set of controls that detect Terraform OCI Cloud Guard resources deviating from security best practices."

  children = [
    control.cloudguard_enabled
  ]

  tags = local.cloudguard_compliance_common_tags
}

control "cloudguard_enabled" {
  title       = "Ensure Cloud Guard is enabled in the root compartment of the tenancy"
  description = "Cloud Guard detects misconfigured resources and insecure activity within a tenancy and provides security administrators with the visibility to resolve these issues. Upon detection, Cloud Guard can suggest, assist, or take corrective actions to mitigate these issues. Cloud Guard should be enabled in the root compartment of your tenancy with the default configuration, activity detectors and responders."
  sql           = query.cloudguard_enabled.sql

  tags = local.cloudguard_compliance_common_tags

}