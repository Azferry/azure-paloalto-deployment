
locals {
  debug_output = {
    /* Json Definitions */
    # definitions_json = local.definitions_json
    # definitions_dataset_from_json = local.definitions_dataset_from_json
    # definitions_map_from_json = local.definitions_map_from_json
    # palo_nva = local.palo_nva

    /* Resource Groups */
    # resource_groups = local.resource_groups

    /* Market place agreement */
    # palo_marketplace_agreements = local.palo_marketplace_agreements

    /* Virtual Network */
    # virtual_network = local.virtual_network
    # subnets = local.subnets
    # azurerm_vnet = local.azurerm_vnet
    # azurerm_vnet_sn = local.azurerm_vnet_sn

    /* NVA Palo */
    # azurerm_vm = local.azurerm_vm
    # network_interfaces = local.network_interfaces
    # azurerm_nic = local.azurerm_nic

    /* Public IP */
    # public_ip = local.public_ip

    /* Network Security Group */
    # network_security_group = local.network_security_group
    # nsg_attach_sn = local.nsg_attach_sn
    # azurerm_attach_nsg_sn = local.azurerm_attach_nsg_sn
    # azurerm_nsg = local.azurerm_nsg
  }
}


output "debug" {
  value = local.debug_output
}
