## v0.2 [2022-05-04]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#11](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/pull/11))

_Breaking Change_

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
