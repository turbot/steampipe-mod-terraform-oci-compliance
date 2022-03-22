locals {
  blockstorage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "blockstorage"
  })
}

benchmark "blockstorage" {
  title       = "Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI Storage resources deviating from security best practices."

  children = [
    control.blockstorage_boot_volume_backup_encryption_enabled,
    control.blockstorage_boot_volume_encryption_enabled,
    control.blockstorage_volume_encryption_enabled
  ]

  tags = local.blockstorage_compliance_common_tags
}

control "blockstorage_boot_volume_backup_encryption_enabled" {
  title       = "Boot volume backup encryption should be enabled"
  description = "Ensure boot volume backups are encrypted at rest to protect sensitive data."
  sql           = query.blockstorage_boot_volume_backup_encryption_enabled.sql

  tags = local.blockstorage_compliance_common_tags

}

control "blockstorage_boot_volume_encryption_enabled" {
  title       = "Boot volume encryption should be enabled"
  description = "Ensure boot volume is encrypted at rest to protect sensitive data."
  sql           = query.blockstorage_boot_volume_encryption_enabled.sql

  tags = local.blockstorage_compliance_common_tags
}

control "blockstorage_volume_encryption_enabled" {
  title       = "Core volume encryption should be enabled"
  description = "Ensure core volume is encrypted at rest to protect sensitive data."
  sql           = query.blockstorage_volume_encryption_enabled.sql

  tags = local.blockstorage_compliance_common_tags
}