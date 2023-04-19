
/*
PA Virtual Router JSON Import
*/
locals {
  zones_definitions_json = tolist(fileset(local.builtin_library_path, "**/zones*.{json,json.tftpl}"))

  zones_definitions_dataset_from_json = {
    for filepath in local.zones_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  zones_definitions_map_from_json = {
    for key, value in local.zones_definitions_dataset_from_json :
    key => values(value)[0]
  }
}

/*
PA Virtual Router configuration
*/
locals {
  zones = flatten([for v in local.zones_definitions_map_from_json : v["config"]])

  pa_zones = {
    for x in local.zones : x.name => x
  }

}


