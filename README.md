# Terraform OCI Compliance Mod for Powerpipe

> [!IMPORTANT]
> [Powerpipe](https://powerpipe.io) is now the preferred way to run this mod! [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)
>
> All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

18 compliance and security controls to test your Terraform OCI resources against security best practices prior to deployment in your OCI accounts.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-oci-compliance/main/docs/terraform_oci_compliance_dashboard.png)

Or in a terminal:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-oci-compliance/main/docs/terraform_oci_compliance_console_output.png)

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.io/mods/turbot/terraform_oci_compliance/controls)**
- **[Named queries →](https://hub.powerpipe.io/mods/turbot/terraform_oci_compliance/queries)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [Terraform plugin](https://hub.steampipe.io/plugins/turbot/terraform) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install terraform
```

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-terraform-oci-compliance
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run terraform_oci_compliance.benchmark.vcn
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Common and Tag Dimensions

The benchmark queries use common properties (like `path` and `connection_name`) and tags that are defined in the form of a default list of strings in the `variables.sp` file. These properties can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.spvars.example steampipe.spvars
vi steampipe.spvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run terraform_oci_compliance.benchmark.vcn --var 'tag_dimensions=["Environment", "Owner"]'
```

Or through environment variables:

```sh
export PP_VAR_common_dimensions='["path", "connection_name"]'
export PP_VAR_tag_dimensions='["Environment", "Owner"]'
powerpipe benchmark run terraform_oci_compliance.benchmark.vcn
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Terraform OCI Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-oci-compliance/labels/help%20wanted)