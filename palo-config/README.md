# Palo alto deployment

## Configuration

* Tags
* Zones
* Interfaces
* Nat Policy
* Virtual Routers

## Test connectivity on interfaces

```shell
ping source UntrustInterfaceIP host 8.8.8.8


Ping host 8.8.8.8 (Management interface)

ping source 10.10.0.52 host 8.8.8.8
ping source 10.10.0.84 host 8.8.8.8
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.29.0 |
| <a name="requirement_panos"></a> [panos](#requirement\_panos) | 1.11.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.29.0 |
| <a name="provider_panos"></a> [panos](#provider\_panos) | 1.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [panos_address_group.pa_addr_groups](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/address_group) | resource |
| [panos_administrative_tag.pa_tags](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/administrative_tag) | resource |
| [panos_ethernet_interface.pa_interface](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/ethernet_interface) | resource |
| [panos_general_settings.pa](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/general_settings) | resource |
| [panos_management_profile.pa_mgt_policy](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/management_profile) | resource |
| [panos_nat_rule_group.pa_nat](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/nat_rule_group) | resource |
| [panos_security_rule_group.pa_sec](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/security_rule_group) | resource |
| [panos_static_route_ipv4.pa_vr_route](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/static_route_ipv4) | resource |
| [panos_virtual_router.pa_vr](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/virtual_router) | resource |
| [panos_zone.pa_zones](https://registry.terraform.io/providers/PaloAltoNetworks/panos/1.11.1/docs/resources/zone) | resource |
| [azurerm_subnet.az_sn_mgt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.az_sn_trust](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.az_sn_untrust](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.azhubvn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pa_hostname"></a> [pa\_hostname](#input\_pa\_hostname) | Host name of the pa device | `string` | n/a | yes |
| <a name="input_pa_sys_timezone"></a> [pa\_sys\_timezone](#input\_pa\_sys\_timezone) | Timezone for the PA device | `string` | `"US/Eastern"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of hub vnet | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_debug"></a> [debug](#output\_debug) | n/a |
<!-- END_TF_DOCS -->
