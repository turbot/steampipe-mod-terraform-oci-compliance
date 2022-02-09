locals {
  objectstorage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "objectstorage"
  })
}

benchmark "objectstorage" {
  title       = "Object Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI Identity and Access Management resources deviating from security best practices."

  children = [
    control.objectstorage_bucket_encryption_enabled,
    control.objectstorage_bucket_public_access_blocked
  ]

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_encryption_enabled" {
  title       = "Object storage bucket encryption should be enabled"
  description = "Password policies are used to enforce password complexity requirements. IAM password policies can be used to ensure password are at least a certain length and are composed of certain characters. It is recommended the password policy require a minimum password length 14 characters and contain 1 non-alphabetic character (Number or 'Special Character')."
  sql           = query.objectstorage_bucket_encryption_enabled.sql

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_public_access_blocked" {
  title       = "Ensure no Object Storage buckets are publicly visible"
  description = "A bucket is a logical container for storing objects. It is associated with a single compartment that has policies that determine what action a user can perform on a bucket and on all the objects in the bucket. It is recommended that no bucket be publicly accessible."
  sql           = query.objectstorage_bucket_public_access_blocked.sql

  tags = merge(local.objectstorage_compliance_common_tags, {
    cis         = true
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "manual"
  })
}