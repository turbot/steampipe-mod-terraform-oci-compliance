# Terraform OCI Compliance

18 compliance and security controls to test your Terraform OCI resources against security best practices prior to deployment in your OCI accounts.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-oci-compliance/main/docs/terraform_oci_compliance_console_output.png)

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
steampipe check terraform_oci_compliance.control.database_db_system_encryption_enabled
```

## Contributing

Have an idea for additional checks or best practices?
- **[Join our Slack community →](https://steampipe.io/community/join)**
- **[Mod developer guide →](https://steampipe.io/docs/using-steampipe/writing-controls)**

**Prerequisites**:
- [Steampipe installed](https://steampipe.io/downloads)
- Steampipe Terraform plugin installed (see above)

**Fork**:
Click on the GitHub Fork Widget. (Don't forget to :star: the repo!)

**Clone**:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-oci-compliance.git
cd steampipe-mod-terraform-oci-compliance
```

Thanks for getting involved! We would love to have you [join our Slack community](https://steampipe.io/community/join) and hang out with other Steampipe Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform OCI Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/labels/help%20wanted)
