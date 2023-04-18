/*
Accept azurerm_marketplace_agreement for products
*/
resource "azurerm_marketplace_agreement" "connectivity" {
  for_each  = local.marketplace_agreements_map
  publisher = each.value.publisher
  offer     = each.value.offer
  plan      = each.value.plan
}


/*
Network Interface Deployment
*/
resource "azurerm_network_interface" "connectivity" {
  for_each                      = local.azurerm_network_interfaces
  name                          = each.value.name
  location                      = each.value.region
  resource_group_name           = each.value.resource_group_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  ip_configuration {
    name                          = each.value.ipconfig_name
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = each.value.allocation
    public_ip_address_id          = each.value.pip
  }
  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_subnet.connectivity,
    azurerm_public_ip.connectivity
  ]
  tags = each.value.tags
}
