/*
PA tag JSON Import
*/
locals {
  tags_definitions_json = tolist(fileset(local.builtin_library_path, "**/tags.{json,json.tftpl}"))

  tags_definitions_dataset_from_json = {
    for filepath in local.tags_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  tags_definitions_map_from_json = {
    for key, value in local.tags_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
}

/*
PA tag
*/
locals {
  tags = flatten([for v in local.tags_definitions_map_from_json : v])

  pa_tags = {
    for i in local.tags : i.name => i
  }
}


/*
PA Dynamic Address Groups JSON Import
*/
locals {
  dynaddrgrp_definitions_json = tolist(fileset(local.builtin_library_path, "**/address_groups.{json,json.tftpl}"))

  dynaddrgrp_definitions_dataset_from_json = {
    for filepath in local.dynaddrgrp_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  dynaddrgrp_definitions_map_from_json = {
    for key, value in local.dynaddrgrp_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }

  dynaddrgrp = flatten([for v in local.dynaddrgrp_definitions_map_from_json : v])

  pa_dynaddrgrp = {
    for i in local.dynaddrgrp : i.name => i
  }

}
