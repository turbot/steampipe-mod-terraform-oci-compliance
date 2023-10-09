locals {
  objectstorage_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/ObjectStorage"
  })
}

benchmark "objectstorage" {
  title       = "Object Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI Object Storage resources deviating from security best practices."

  children = [
    control.objectstorage_bucket_encryption_enabled,
    control.objectstorage_bucket_object_events_enabled,
    control.objectstorage_bucket_public_access_blocked,
    control.objectstorage_bucket_versioning_enabled
  ]

  tags = merge(local.objectstorage_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "objectstorage_bucket_encryption_enabled" {
  title       = "Object Storage bucket encryption should be enabled"
  description = "Ensure that the Object storage buckets are encrypted at rest to protect sensitive data."
  query       = query.objectstorage_bucket_encryption_enabled

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_versioning_enabled" {
  title       = "Object Storage bucket versioning should be enabled"
  description = "Object versioning provides data protection against accidental or malicious object update, overwrite, or deletion. Enabled at the bucket level, versioning directs Object Storage to automatically create an object version each time a new object is uploaded, an existing object is overwritten, or when an object is deleted."
  query       = query.objectstorage_bucket_versioning_enabled

  tags = local.objectstorage_compliance_common_tags
}

control "objectstorage_bucket_public_access_blocked" {
  title       = "Ensure no Object Storage buckets are publicly visible"
  description = "A bucket is a logical container for storing objects. It is associated with a single compartment that has policies that determine what action a user can perform on a bucket and on all the objects in the bucket. It is recommended that no bucket be publicly accessible."
  query       = query.objectstorage_bucket_public_access_blocked

  tags = merge(local.objectstorage_compliance_common_tags, {
    cis = true
  })
}

control "objectstorage_bucket_object_events_enabled" {
  title       = "Object Storage bucket object events should be enabled"
  description = "This control checks whether the Object Storage bucket object events are enabled. Object events are used to track object state changes."
  query       = query.objectstorage_bucket_object_events_enabled

  tags = local.objectstorage_compliance_common_tags
}