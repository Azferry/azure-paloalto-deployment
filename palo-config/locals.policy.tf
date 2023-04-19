/*
PA tag JSON Import
*/
locals {
  nat_policy_definitions_json = tolist(fileset(local.builtin_library_path, "**/nat_*.{json,json.tftpl}"))

  nat_policy_definitions_dataset_from_json = {
    for filepath in local.nat_policy_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  nat_policy_definitions_map_from_json = {
    for key, value in local.nat_policy_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
}

/*
PA tag
*/
locals {
  nat = flatten([for v in local.nat_policy_definitions_map_from_json : v])

  nat_config = [
    for n in local.nat : {
      name        = n.name
      description = "${n.description} - (Cr By, Terraform)"
      group_tags  = n.group_tags
      type        = n.type
      tags        = n.tags
      disable     = n.disable
      original_packet = {
        source_zones          = n.original_packet.source_zones
        destination_zone      = n.original_packet.destination_zone
        destination_interface = n.original_packet.destination_interface
        service               = n.original_packet.service
        source_addresses      = n.original_packet.source_addresses
        destination_addresses = n.original_packet.destination_addresses
      }
      translated_packet = {
        source = {
          dynamic_ip_and_port = n.translated_packet.source.dynamic_ip_and_port
          static_ip           = n.translated_packet.source.static_ip
          dynamic_ip          = n.translated_packet.source.dynamic_ip
        }


      }
    }
  ]

  pa_nat_policy = {
    for i in local.nat_config : i.name => i
  }
}


/*
PA Security Policy JSON Import
*/
locals {
  sec_policy_definitions_json = tolist(fileset(local.builtin_library_path, "**/sec_policy*.{json,json.tftpl}"))

  sec_policy_definitions_dataset_from_json = {
    for filepath in local.sec_policy_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  sec_policy_definitions_map_from_json = {
    for key, value in local.sec_policy_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
}

/*
PA Security Policy JSON Import
*/
locals {
  sec = flatten([for v in local.sec_policy_definitions_map_from_json : v if v["deploy_policy"]])

  sec_config = [
    for p in local.sec : {
      name                  = p.name
      description           = "${p.description} - (Cr By, Terraform)"
      audit_comment         = p.audit_comment
      source_zones          = p.source_zones
      source_addresses      = p.source_addresses
      source_users          = p.source_users
      destination_zones     = p.destination_zones
      destination_addresses = p.destination_addresses
      applications          = p.applications
      services              = p.services
      categories            = p.categories
      action                = p.action
      log_start             = p.log_start
      log_end               = p.log_end
      disabled              = p.disabled
      tags                  = p.tags
      type                  = p.type
    }
  ]

  pa_sec_policy = {
    for i in local.sec_config : i.name => i
  }
}
