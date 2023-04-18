
locals {
  debug_output = {
    /* Connectivity Module Output */
    # azurerm_network_interfaces = local.azurerm_network_interfaces
    # paloalto_firewalls = local.paloalto_firewalls
    # azurerm_nsg = local.azurerm_nsg
    # azurerm_public_ip = local.azurerm_public_ip
    # azurerm_bastion = local.azurerm_bastion
    # azurerm_subnet = local.azurerm_subnet
    # azurerm_virtual_network = local.azurerm_virtual_network
    # azurerm_resource_group = local.azurerm_resource_group
    # azurerm_network_interfaces = local.azurerm_network_interfaces

    /* Market place agreement */
    # palo_terms = local.palo_terms
    # marketplace_agreements_concat = local.marketplace_agreements_concat
    # marketplace_agreements = local.marketplace_agreements
    # marketplace_agreements_map = local.marketplace_agreements_map
  }
}


output "debug" {
  value = local.debug_output
}