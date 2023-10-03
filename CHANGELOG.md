## v0.6 [2023-10-03]

_Enhancements_

- Updated the queries to use the `attributes_std` and `address` columns from the `terraform_resource` table instead of `arguments`, `type` and `name` columns for better support of terraform state files. ([#34](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/34))

_Dependencies_

- Terraform plugin `v0.10.0` or higher is now required. ([#34](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/34))

## v0.5 [2023-06-15]

_What's new?_

- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/terraform_oci_compliance/variables)) ([#26](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/26))
- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/terraform_oci_compliance/variables)) ([#26](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/26))

## v0.4 [2022-05-25]

_What's new?_

- New VCN controls added: ([#19](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/19))
  - vcn_network_security_group_restrict_ingress_rdp_all (`steampipe check control.vcn_network_security_group_restrict_ingress_rdp_all`)
  - vcn_network_security_group_restrict_ingress_ssh_all (`steampipe check control.vcn_network_security_group_restrict_ingress_ssh_all`)

_Bug fixes_

- Fixed `vcn_security_list_restrict_ingress_rdp_all` and `vcn_security_list_restrict_ingress_ssh_all` queries to correctly check if the security lists restrict ingress access to ports `3389` and `22` respectively. ([#19](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/19))

## v0.3 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#15](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/15))

## v0.2 [2022-05-04]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#11](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/11))

_Breaking changes_

- Renamed the `network` benchmark (`steampipe check terraform_oci_compliance.benchmark.network`) to `vcn` benchmark (`steampipe check terraform_oci_compliance.benchmark.vcn`) to maintain consistency with OCI documentation. ([#11](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/11))
- Renamed the following controls and queries to maintain consistency with the benchmark names:
  - `network_default_security_group_allow_icmp_only` to `vcn_default_security_group_allow_icmp_only`
  - `network_security_list_restrict_ingress_rdp_all` to `vcn_security_list_restrict_ingress_rdp_all`
  - `network_security_list_restrict_ingress_ssh_all` to `vcn_list_restrict_ingress_ssh_all`
  - `network_subnet_public_access_blocked` to `vcn_subnet_public_access_blocked`

## v0.1 [2022-03-24]

_What's new?_

- Added 8 benchmarks and 18 controls to check Terraform OCI resources against security best practices. Controls for the following services have been added:
  - Block Storage
  - Cloud Guard
  - Compute
  - Database
  - File Storage
  - Identity and Access Management
  - Network
  - Object Storage
