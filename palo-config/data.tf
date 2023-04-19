data "azurerm_virtual_network" "azhubvn" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "az_sn_mgt" {
  name                 = "palo-mgt-sn01"
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}

data "azurerm_subnet" "az_sn_trust" {
  name                 = "palo-trust-sn01"
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}

data "azurerm_subnet" "az_sn_untrust" {
  name                 = "palo-untrust-sn01"
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}
