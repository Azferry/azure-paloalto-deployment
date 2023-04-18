/*
Accept azurerm_marketplace_agreement for products
Will show an error if the subscription has already accepted the agreement
*/
# resource "azurerm_marketplace_agreement" "connectivity" {
#   for_each  = local.marketplace_agreements_map
#   publisher = each.value.publisher
#   offer     = each.value.offer
#   plan      = each.value.plan
# }

/*
Resource Groups Deployment
*/
resource "azurerm_resource_group" "az_rg" {
  for_each = local.resource_groups
  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}

/*
Network Interface Deployment
*/
resource "azurerm_network_interface" "connectivity" {
  for_each                      = local.azurerm_nic
  name                          = each.value.name
  location                      = each.value.region
  resource_group_name           = each.value.resource_group_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  ip_configuration {
    name                          = each.value.ip_configurations.name
    subnet_id                     = each.value.ip_configurations.subnet_id
    private_ip_address_allocation = each.value.ip_configurations.allocation
    public_ip_address_id          = each.value.ip_configurations.pip
  }
  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_subnet.connectivity,
    azurerm_public_ip.connectivity
  ]
  tags = each.value.tags
}
