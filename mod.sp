// Benchmarks and controls for specific services should override the "service" tag
locals {
  terraform_oci_compliance_common_tags = {
    category = "Compliance"
    plugin   = "terraform"
    service  = "OCI"
  }
}

mod "terraform_oci_compliance" {
  # Hub metadata
  title         = "Terraform OCI Compliance"
  description   = "Run compliance and security controls to detect Terraform OCI resources deviating from security best practices prior to deployment in your OCI accounts."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-oci-compliance.svg"
  categories    = ["oci", "compliance", "iac", "security", "terraform"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform OCI resources deviating from security best practices prior to deployment in your OCI accounts."
    image       = "/images/mods/turbot/terraform-oci-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.5"
    }
  }
}
