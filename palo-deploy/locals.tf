
/*
General Local Vars
*/
locals {
  prefix               = var.prefix
  region               = var.azure_region
  subscription_id      = data.azurerm_client_config.current.subscription_id
  tenant_id            = data.azurerm_client_config.current.tenant_id
  builtin_library_path = "."

  default_vm_username     = var.default_vm_username
  default_vm_userpassword = var.default_vm_userpassword
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

  palo_nva = [for k, v in local.definitions_map_from_json : v["palo_nva"] if v["enabled"]]
  hub_vnet = [for k, v in local.definitions_map_from_json : v["hub_network"] if v["enabled"]]
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

/* 
Hub Networks
*/
locals {
  virtual_network = [
    for key, vn in local.definitions_map_from_json : {
      name                = try("${key}-vn", vn.hub_network.name)
      resource_id         = "${local.resource_groups[key].resource_id}/providers/Microsoft.Network/virtualNetworks/${key}-vn"
      location            = local.resource_groups[key].location
      resource_group_name = local.resource_groups[key].name
      tags                = local.tags
      vnet_cidr           = vn.hub_network.address_space
      vnet_subnets = [
        for x in vn.hub_network.subnets : {
          name        = x.name
          cidr        = x.address_prefix
          resource_id = "${local.resource_groups[key].resource_id}/providers/Microsoft.Network/virtualNetworks/${key}-vn/subnets/${x.name}"
        }
      ]
    }
  ]

  subnets = flatten([
    for vn in local.virtual_network : [
      for sn in vn.vnet_subnets : {
        name                = sn.name
        vn_name             = vn.name
        resource_group_name = vn.resource_group_name
        location            = vn.location
        cidr                = sn.cidr
        # attach_nsg     = try(sn.attach_nsg != false, true)
        sn_id = sn.resource_id
        # route_table_id = "/subscriptions/${local.subscription_id}/resourceGroups/${vn.rg_name}/providers/Microsoft.Network/routeTables/${vn.cpi_prefix}-vn${vn.series}-udr"
      }
    ]
  ])

  azurerm_vnet = {
    for x in local.virtual_network : x.resource_group_name => x
  }

  azurerm_vnet_sn = {
    for x in local.subnets : "${x.resource_group_name}-${x.name}" => x
  }

  # sn_attach_nsg = {
  #   for x in local.azurerm_vnet_sn : "${x.rg_name}-${x.name}" => x if try(x.attach_nsg != false, true)
  # }

  # nsg_attach_sn = [
  #   for cpi in local.sn_attach_nsg : {
  #     nsg_id = local.azurerm_nsg[cpi.rg_name].resource_id
  #     sn_id  = cpi.sn_id
  #   }
  # ]

  # azurerm_attach_nsg_sn = {
  #   for x in local.nsg_attach_sn : x.sn_id => x
  # }
}

/* 
Virtual Machines
*/
locals {
  vm = [
    for key, vm in local.definitions_map_from_json : {
      name                = try("${key}-vm", vm.palo_nva.name)
      resource_id         = "${local.resource_groups[key].resource_id}/providers/Microsoft.Compute/virtualMachines/${key}-vm"
      region              = local.resource_groups[key].location
      resource_group_name = local.resource_groups[key].name
      tags                = local.tags
      vm_disktype         = vm.palo_nva.vm_disktype
      disk_name           = try("${key}-vm-osdisk", vm.palo_nva.disk_name)
      vm_size             = vm.palo_nva.vm_size
      vm_username         = try(vm.palo_nva.vm_username, local.default_vm_username)
      vm_userpassword     = try(vm.palo_nva.vm_userpassword, local.default_vm_userpassword)
      vm_prefix           = try(vm.vm_prefix, key)
      image_reference     = vm.palo_nva.source_image_reference
      plan                = vm.palo_nva.plan
      nic_prefix          = "${try("${key}", vm.palo_nva.name)}-nic"
      vm_nics = [
        for x in vm.palo_nva.network_interfaces : {
          name        = "${try("${key}-vm", vm.palo_nva.name)}-${x.post_fix}"
          resource_id = "${local.resource_groups[key].resource_id}/providers/Microsoft.Network/networkInterfaces/${try("${key}-vm", vm.palo_nva.name)}-${x.post_fix}"
          ip_configurations = {
            name      = "IPConfig"
            subnet_id = local.azurerm_vnet_sn["${local.resource_groups[key].name}-${x.subnet}"].sn_id
            #     private_ip_address_allocation = try(y.private_ip_address_allocation, "Dynamic")
            #     private_ip_address = try(y.private_ip_address, null)
            #     public_ip_address_id = try(y.public_ip_address_id, null)
          }
        }
      ]
    }
  ]

  network_interfaces = flatten([
    for key, vm in local.definitions_map_from_json : [
      for x in vm.palo_nva.network_interfaces : {
        name                          = "${try("${key}", vm.palo_nva.name)}-nic-${x.post_fix}"
        resource_id                   = "${local.resource_groups[key].resource_id}/providers/Microsoft.Network/networkInterfaces/${try("${key}-vm", vm.palo_nva.name)}-${x.post_fix}"
        region                        = local.resource_groups[key].location
        resource_group_name           = local.resource_groups[key].name
        tags                          = local.tags
        enable_ip_forwarding          = x.enable_ip_forwarding
        enable_accelerated_networking = x.enable_accelerated_networking
        ip_configurations = {
          name       = "IPConfig"
          subnet_id  = local.azurerm_vnet_sn["${local.resource_groups[key].name}-${x.subnet}"].sn_id
          allocation = try(x.private_ip_address_allocation, "Dynamic")
          #     private_ip_address = try(y.private_ip_address, null)
          pip = try(local.azurerm_public_ip["${try("${key}", vm.palo_nva.name)}-nic-${x.post_fix}-pip"].resource_id, null)
        }
      }
    ]
  ])

  azurerm_nic = {
    for x in local.network_interfaces : x.name => x
  }

  azurerm_vm = {
    for x in local.vm : x.resource_group_name => x
  }
}

/*
Public IP Addresses
*/
locals {
  public_ip = flatten([
    for key, p in local.definitions_map_from_json : [
      for x in p.palo_nva.network_interfaces : {
        name                = "${try("${key}", p.palo_nva.name)}-nic-${x.post_fix}-pip"
        resource_id         = "${local.resource_groups[key].resource_id}/providers/Microsoft.Network/publicIPAddresses/${try("${key}", p.palo_nva.name)}-nic-${x.post_fix}-pip"
        region              = local.resource_groups[key].location
        resource_group_name = local.resource_groups[key].name
        tags                = local.tags
        allocation_method   = try(x.public_ip_allocation_method, "Static")
        sku                 = try(x.public_ip_sku, "Standard")
        idle_timeout        = try(x.idle_timeout, 4)
        en_pip              = try(x.public_ip, false)
        domain_name_label   = "${try("${key}", p.palo_nva.name)}-nic-${x.post_fix}-pip"
      }
    ]
  ])

  azurerm_public_ip = {
    for x in local.public_ip : x.name => x
    if x.en_pip == true
  }
}
