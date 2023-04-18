resource "azurerm_virtual_network" "connectivity" {
  for_each = local.azurerm_virtual_network

  # Mandatory resource attributes
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  location            = each.value.location

  # Optional resource attributes
  bgp_community = each.value.bgp_community
  dns_servers   = each.value.dns_servers
  tags          = each.value.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.az_rg,
    # azurerm_network_ddos_protection_plan.connectivity,
  ]

}

resource "azurerm_subnet" "connectivity" {
  for_each = local.azurerm_subnet

  # Mandatory resource attributes
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_virtual_network.connectivity,
    # azurerm_network_ddos_protection_plan.connectivity,
  ]

}


resource "azurerm_public_ip" "connectivity" {
  for_each = local.azurerm_public_ip

  # Mandatory resource attributes
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method

  # Optional resource attributes
  sku                     = each.value.sku
  zones                   = each.value.zones
  ip_version              = each.value.ip_version
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  domain_name_label       = each.value.domain_name_label
  reverse_fqdn            = each.value.reverse_fqdn
  public_ip_prefix_id     = each.value.public_ip_prefix_id
  ip_tags                 = each.value.ip_tags
  tags                    = each.value.tags

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.az_rg
  ]
}

resource "azurerm_network_security_group" "connectivity" {
  for_each            = local.azurerm_nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule = each.value.security_rules

  tags = each.value.tags
  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.az_rg
  ]
}

resource "azurerm_subnet_network_security_group_association" "connectivity" {
  for_each                  = local.azurerm_nsg
  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.nsg_resource_id

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_network_security_group.connectivity,
    azurerm_subnet.connectivity
  ]
}


