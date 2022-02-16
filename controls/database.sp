locals {
  database_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "database"
  })
}

benchmark "database" {
  title       = "Database Service"
  description = "This benchmark provides a set of controls that detect Terraform OCI Database resources deviating from security best practices."

  children = [
    control.database_db_encryption_enabled,
    control.database_db_home_encryption_enabled,
    control.database_db_system_encryption_enabled
  ]

  tags = local.database_compliance_common_tags
}

control "database_db_encryption_enabled" {
  title       = "OCI database encryption should be enabled"
  description = "Ensure OCI databases are encrypted at rest to protect sensitive data."
  sql           = query.database_db_encryption_enabled.sql

  tags = local.database_compliance_common_tags

}

control "database_db_home_encryption_enabled" {
  title       = "OCI database home encryption should be enabled"
  description = "Ensure OCI database homes are encrypted at rest to protect sensitive data."
  sql           = query.database_db_home_encryption_enabled.sql

  tags = local.database_compliance_common_tags

}

control "database_db_system_encryption_enabled" {
  title       = "OCI database system encryption should be enabled"
  description = "Ensure OCI database systems are encrypted at rest to protect sensitive data."
  sql           = query.database_db_system_encryption_enabled.sql

  tags = local.database_compliance_common_tags

}