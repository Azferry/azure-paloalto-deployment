
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

  }
}


output "debug" {
  value = local.debug_output
}
