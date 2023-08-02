locals {
  database_compliance_common_tags = merge(local.terraform_oci_compliance_common_tags, {
    service = "OCI/Database"
  })
}

benchmark "database" {
  title       = "Database"
  description = "This benchmark provides a set of controls that detect Terraform OCI Database resources deviating from security best practices."

  children = [
    control.database_db_encryption_enabled,
    control.database_db_home_encryption_enabled,
    control.database_db_system_encryption_enabled
  ]

  tags = merge(local.database_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "database_db_encryption_enabled" {
  title       = "Database encryption should be enabled"
  description = "Ensure databases are encrypted at rest to protect sensitive data."
  query       = query.database_db_encryption_enabled

  tags = local.database_compliance_common_tags

}

control "database_db_home_encryption_enabled" {
  title       = "Database home encryption should be enabled"
  description = "Ensure database homes are encrypted at rest to protect sensitive data."
  query       = query.database_db_home_encryption_enabled

  tags = local.database_compliance_common_tags

}

control "database_db_system_encryption_enabled" {
  title       = "Database system encryption should be enabled"
  description = "Ensure database systems are encrypted at rest to protect sensitive data."
  query       = query.database_db_system_encryption_enabled

  tags = local.database_compliance_common_tags

}