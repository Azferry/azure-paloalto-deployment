
/* 
Virutal Network deployment
*/
resource "azurerm_virtual_network" "connectivity" {
  for_each = local.azurerm_vnet

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.vnet_cidr
  location            = each.value.location
  # dns_servers   = each.value.dns_servers

  tags = each.value.tags
  depends_on = [
    azurerm_resource_group.az_rg
  ]
}

/* 
Subnet deployment for Virtual Network
*/
resource "azurerm_subnet" "connectivity" {
  for_each = local.azurerm_vnet_sn

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vn_name
  address_prefixes     = each.value.cidr

  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_virtual_network.connectivity,
  ]
}


/* 
Public IP Deployment
*/
resource "azurerm_public_ip" "connectivity" {
  for_each = local.azurerm_public_ip

  name                = each.value.name
  location            = each.value.region
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  # zones                   = each.value.zones
  # ip_version              = each.value.ip_version
  idle_timeout_in_minutes = each.value.idle_timeout
  # domain_name_label       = each.value.domain_name_label
  # reverse_fqdn            = each.value.reverse_fqdn
  # public_ip_prefix_id     = each.value.public_ip_prefix_id
  # ip_tags                 = each.value.ip_tags
  tags = each.value.tags

  depends_on = [
    azurerm_resource_group.az_rg
  ]
}

/* 
Network Security Group Deployment
*/
# resource "azurerm_network_security_group" "connectivity" {
#   for_each            = local.azurerm_nsg
#   name                = each.value.name
#   location            = each.value.location
#   resource_group_name = each.value.resource_group_name

#   security_rule = each.value.security_rules

#   tags = each.value.tags
#   # Set explicit dependencies
#   depends_on = [
#     azurerm_resource_group.az_rg
#   ]
# }

/* 
Subnet Attchment to Network Security Group
*/
# resource "azurerm_subnet_network_security_group_association" "connectivity" {
#   for_each                  = local.azurerm_nsg
#   subnet_id                 = each.value.subnet_id
#   network_security_group_id = each.value.nsg_resource_id

#   # Set explicit dependencies
#   depends_on = [
#     azurerm_resource_group.az_rg,
#     azurerm_network_security_group.connectivity,
#     azurerm_subnet.connectivity
#   ]
# }


