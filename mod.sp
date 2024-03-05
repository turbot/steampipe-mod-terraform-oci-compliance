mod "terraform_oci_compliance" {
  # Hub metadata
  title         = "Terraform OCI Compliance"
  description   = "Run compliance and security controls to detect Terraform OCI resources deviating from security best practices prior to deployment in your OCI accounts."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-oci-compliance.svg"
  categories    = ["oci", "compliance", "iac", "security", "terraform"]

  opengraph {
    title       = "Powerpipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform OCI resources deviating from security best practices prior to deployment in your OCI accounts."
    image       = "/images/mods/turbot/terraform-oci-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      min_version = "0.10.0"
    }
  }
}
