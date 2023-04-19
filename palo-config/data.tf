data "azurerm_virtual_network" "azhubvn" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "az_sn_mgt" {
  name                 = var.mgt_sn_name
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}

data "azurerm_subnet" "az_sn_trust" {
  name                 = var.trust_sn_name
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}

data "azurerm_subnet" "az_sn_untrust" {
  name                 = var.untrust_sn_name
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}

data "azurerm_subnet" "az_sn_shared" {
  name                 = var.shared_sn_name
  virtual_network_name = data.azurerm_virtual_network.azhubvn.name
  resource_group_name  = data.azurerm_virtual_network.azhubvn.resource_group_name
}
