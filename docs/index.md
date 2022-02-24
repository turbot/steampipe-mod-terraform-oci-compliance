---
repository: "https://github.com/turbot/steampipe-mod-terraform-oci-compliance"
---

# Terraform OCI Compliance

Run compliance and security controls to detect Terraform OCI resources deviating from security best practices prior to deployment in your OCI accounts.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-oci-compliance/main/docs/terraform_oci_compliance_console_output.png)

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/terraform_oci_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/terraform_oci_compliance/queries)**

## Get started

### Installation

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-oci-compliance.git
```

Install the Terraform plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install terraform
```

### Configuration

By default, the Terraform plugin configuration loads Terraform configuration
files in your current working directory. If you are running benchmarks and
controls from the current working directory, no extra plugin configuration is
necessary.

If you want to run benchmarks and controls across multiple directories, they
can be run from within the `steampipe-mod-terraform-oci-compliance` mod
directory after configuring the Terraform plugin configuration:

```sh
vi ~/.steampipe/config/terraform.spc
```

```hcl
connection "terraform" {
  plugin = "terraform"
  paths  = ["/path/to/files/*.tf", "/path/to/more/files/*.tf"]
}
```

For more details on connection configuration, please refer to [Terraform Plugin Configuration](https://hub.steampipe.io/plugins/turbot/terraform#configuration).

### Usage

If you are running from the current working directory containing your Terraform
configuration files, the Steampipe workspace must be set to the location where
you downloaded the `steampipe-mod-terraform-oci-compliance` mod:

Set through an environment variable:

```sh
export STEAMPIPE_WORKSPACE_CHDIR=/path/to/steampipe-mod-terraform-oci-compliance
steampipe check all
```

Set through the CLI argument:

```sh
steampipe check all --workspace-chdir=/path/to/steampipe-mod-terraform-oci-compliance
```

However, if you are running from within the
`steampipe-mod-terraform-oci-compliance` mod directory and `paths` was
configured in the Terraform plugin configuration, the Steampipe workspace does
not need to be set (since you are already in the Steampipe workspace
directory).

Run all benchmarks:

```sh
steampipe check all
```

Run all benchmarks for a specific compliance framework using tags:

```sh
steampipe check all --tag cis=true
```

Run a benchmark:

```sh
steampipe check terraform_oci_compliance.benchmark.cloudguard
```

Run a specific control:

```sh
steampipe check terraform_oci_compliance.control.core_boot_volume_encryption_enabled
```

### Credentials

This mod uses the credentials configured in the [Steampipe Terraform plugin](https://hub.steampipe.io/plugins/turbot/terraform).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-terraform-oci-compliance)
* Community: [Slack Channel](https://steampipe.io/community/join)
