

resource "azurerm_route_table" "udr" {
  name                          = "trust-udr"
  location                      = data.azurerm_virtual_network.azhubvn.location
  resource_group_name           = data.azurerm_virtual_network.azhubvn.resource_group_name
  disable_bgp_route_propagation = false

  route {
    address_prefix = "0.0.0.0/0"
    name           = "default_rt"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_network_interface.trust_nic.private_ip_address
  }
}


resource "azurerm_subnet_route_table_association" "udr_association" {
  subnet_id      = data.azurerm_subnet.az_sn_shared.id
  route_table_id = azurerm_route_table.udr.id

  depends_on = [
    azurerm_route_table.udr
  ]
}
