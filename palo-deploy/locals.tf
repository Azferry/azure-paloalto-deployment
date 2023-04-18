
/*
General Local Vars
*/
locals {
  prefix               = var.prefix
  region               = var.azure_region
  subscription_id      = data.azurerm_client_config.current.subscription_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
  builtin_library_path = "."
  template_file_vars = {
    prefix = local.prefix
    region = local.region
  }
  tags = {
    "Environment" = "Dev"
  }
}

/*
Build definitions form Dataset json files
*/
locals {
  definitions_json = tolist(fileset(local.builtin_library_path, "pavm*.json"))

  definitions_dataset_from_json = {
    for filepath in local.definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  definitions_map_from_json = {
    for key, value in local.definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }

  palo_nva = [for v in local.definitions_map_from_json : v["palo_nva"] if v["enabled"]]
  hub_vnet = [for v in local.definitions_map_from_json : v["hub_network"] if v["enabled"]]
}

/*
Resource Groups Local Vars
*/
locals {
  resource_groups = {
    for key, rg in local.definitions_map_from_json :
    key => {
      location    = rg["region"]
      tags        = local.tags
      name        = "${key}-rg"
      resource_id = "/subscriptions/${local.subscription_id}/resourceGroups/${key}-rg"
      vm_prefix   = try(rg["vm_prefix"], key)
    }
  }
}

/* 
Market Place Terms 
*/
locals {
  palo_marketplace_agreements = distinct(flatten([
    for x in local.palo_nva : {
      publisher = x.source_image_reference.publisher
      offer     = x.source_image_reference.offer
      plan      = x.plan.name
    }
  ]))

  marketplace_agreements_map = {
    for x in local.palo_marketplace_agreements : "${x.publisher}_${x.offer}_${x.plan}" => x
  }
}

