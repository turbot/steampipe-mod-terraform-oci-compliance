locals {
  filestorage_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/FileStorage"
  })
}

benchmark "filestorage" {
  title       = "File Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI File Storage resources deviating from security best practices."

  children = [
    control.file_storage_file_system_encryption_enabled
  ]

  tags = merge(local.filestorage_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "file_storage_file_system_encryption_enabled" {
  title       = "File Storage file system encryption should be enabled"
  description = "Ensure File Storage file systems are encrypted at rest to protect sensitive data."
  query       = query.file_storage_file_system_encryption_enabled

  tags = local.filestorage_compliance_common_tags

}