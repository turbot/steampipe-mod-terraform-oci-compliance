locals {
  blockstorage_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/BlockStorage"
  })
}

benchmark "blockstorage" {
  title       = "Block Storage"
  description = "This benchmark provides a set of controls that detect Terraform OCI Block Storage resources deviating from security best practices."

  children = [
    control.blockstorage_block_volume_backup_enabled,
    control.blockstorage_block_volume_encryption_enabled,
    control.blockstorage_boot_volume_backup_encryption_enabled,
    control.blockstorage_boot_volume_encryption_enabled
  ]

  tags = merge(local.blockstorage_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "blockstorage_boot_volume_backup_encryption_enabled" {
  title       = "Block Storage boot volume backup encryption should be enabled"
  description = "Ensure Block Storage boot volume backups are encrypted at rest to protect sensitive data."
  query       = query.blockstorage_boot_volume_backup_encryption_enabled

  tags = local.blockstorage_compliance_common_tags

}

control "blockstorage_boot_volume_encryption_enabled" {
  title       = "Block Storage boot volume encryption should be enabled"
  description = "Ensure Block Storage boot volumes are encrypted at rest to protect sensitive data."
  query       = query.blockstorage_boot_volume_encryption_enabled

  tags = local.blockstorage_compliance_common_tags
}

control "blockstorage_block_volume_encryption_enabled" {
  title       = "Block Storage block volume encryption should be enabled"
  description = "Ensure Block Storage block volumes are encrypted at rest to protect sensitive data."
  query       = query.blockstorage_block_volume_encryption_enabled

  tags = local.blockstorage_compliance_common_tags
}

control "blockstorage_block_volume_backup_enabled" {
  title       = "Block Storage block volume backup should be enabled"
  description = "This control checks whether block volume backups are enabled. Block volume backups are used to create point-in-time copies of block volumes that can be used to create new block volumes or overwrite existing block volumes."
  query       = query.blockstorage_block_volume_backup_enabled

  tags = local.blockstorage_compliance_common_tags
}