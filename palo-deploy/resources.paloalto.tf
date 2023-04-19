

resource "azurerm_linux_virtual_machine" "FW" {
  for_each            = local.azurerm_vm
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.region
  size                = each.value.vm_size

  network_interface_ids = [ ## Order matters
    azurerm_network_interface.connectivity["${each.value.nic_prefix}-mgt"].id,
    azurerm_network_interface.connectivity["${each.value.nic_prefix}-untrust"].id,
    azurerm_network_interface.connectivity["${each.value.nic_prefix}-trust"].id
  ]

  disable_password_authentication = false
  admin_password                  = each.value.vm_userpassword
  admin_username                  = each.value.vm_username

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = each.value.vm_disktype
    name                 = each.value.disk_name
  }

  source_image_reference {
    publisher = each.value.image_reference.publisher
    offer     = each.value.image_reference.offer
    sku       = each.value.image_reference.sku
    version   = each.value.image_reference.version
  }
  plan {
    name      = each.value.plan.name
    publisher = each.value.plan.publisher
    product   = each.value.plan.product
  }
  tags = each.value.tags

  lifecycle {
    ignore_changes = [
      admin_password
    ]
  }
  depends_on = [
    azurerm_resource_group.az_rg,
    azurerm_subnet.connectivity,
    azurerm_public_ip.connectivity,
    azurerm_network_interface.connectivity,
    # azurerm_marketplace_agreement.connectivity
  ]
}
