locals {
  objectstorage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "objectstorage"
  })
}

benchmark "objectstorage" {
  title       = "Object Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI Object Storage resources deviating from security best practices."

  children = [
    control.objectstorage_bucket_encryption_enabled,
    control.objectstorage_bucket_public_access_blocked
  ]

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_encryption_enabled" {
  title       = "Object storage bucket encryption should be enabled"
  description = "Ensure that the Object storage buckets are encrypted at rest to protect sensitive data."
  sql           = query.objectstorage_bucket_encryption_enabled.sql

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_public_access_blocked" {
  title       = "Ensure no Object Storage buckets are publicly visible"
  description = "A bucket is a logical container for storing objects. It is associated with a single compartment that has policies that determine what action a user can perform on a bucket and on all the objects in the bucket. It is recommended that no bucket be publicly accessible."
  sql           = query.objectstorage_bucket_public_access_blocked.sql

  tags = merge(local.objectstorage_compliance_common_tags, {
    cis         = true
  })
}