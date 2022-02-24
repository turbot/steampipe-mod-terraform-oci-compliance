locals {
  filestorage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "filestorage"
  })
}

benchmark "filestorage" {
  title       = "File Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI File Storage resources deviating from security best practices."

  children = [
    control.file_storage_file_system_encryption_enabled
  ]

  tags = local.filestorage_compliance_common_tags
}

control "file_storage_file_system_encryption_enabled" {
  title       = "File Storage file system encryption should be enabled"
  description = "Ensure file storage file systems are encrypted at rest to protect sensitive data."
  sql           = query.file_storage_file_system_encryption_enabled.sql

  tags = local.filestorage_compliance_common_tags

}