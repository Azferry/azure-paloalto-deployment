
/*
General Local Vars
*/
locals {
  tags                = var.tags
  subscription_id_hub = var.subscription_id_hub
  environment         = var.environment
  root                = var.root
}

/*
Map objects from module output
*/
locals {
  azurerm_resource_group = {
    for x in module.connectivity_hub_data.azurerm_resource_group : x.name => x
  }

  azurerm_virtual_network = {
    for x in module.connectivity_hub_data.azurerm_virtual_network : x.name => x
  }

  azurerm_subnet = {
    for x in module.connectivity_hub_data.azurerm_subnet : x.resource_id => x
  }

  azurerm_bastion = {
    for x in module.connectivity_hub_data.azurerm_bastion : x.subnet_id => x
  }

  azurerm_public_ip = {
    for x in module.connectivity_hub_data.azurerm_public_ip : x.resource_id => x
  }

  azurerm_nsg = {
    for x in module.connectivity_hub_data.azurerm_nsg : x.name => x
  }

  paloalto_firewalls = {
    for x in module.connectivity_hub_data.paloalto_firewalls : x.name => x
  }

  azurerm_network_interfaces = {
    for x in module.connectivity_hub_data.azurerm_network_interfaces : x.name => x
  }
}

/* 
Market Place Terms 
*/
locals {
  /* Create list of all market place terms */
  palo_terms = flatten([
    for x in module.connectivity_hub_data.paloalto_firewalls : {
      publisher = x.image_reference.publisher
      offer     = x.image_reference.offer
      plan      = x.plan.name
    }
  ])

  /* Merge all the offer lists and flatten */
  marketplace_agreements_concat = flatten([
    for x in concat(
      local.palo_terms
    ) : x
  ])

  /* Select distinct offers and convert to map */
  marketplace_agreements = distinct(local.marketplace_agreements_concat)
  marketplace_agreements_map = {
    for x in local.marketplace_agreements : "${x.publisher}_${x.offer}_${x.plan}" => x
  }
}

