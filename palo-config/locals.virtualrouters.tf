
/*
PA Virtual Router JSON Import
*/
locals {
  virtual_router_definitions_json = tolist(fileset(local.builtin_library_path, "**/*_vr.{json,json.tftpl}"))

  virtual_router_definitions_dataset_from_json = {
    for filepath in local.virtual_router_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  virtual_router_definitions_map_from_json = {
    for key, value in local.virtual_router_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
}

/*
PA Virtual Router configuration
*/
locals {
  virtual_routers = [for v in local.virtual_router_definitions_map_from_json : v if v["enabled"]]

  virtual_routers_config = [
    for vr in local.virtual_routers : {
      name        = vr.name
      static_dist = vr.static_distance
      interfaces  = vr.interfaces
      routes = [
        for r in vr.routes : {
          name           = r.name
          virtual_router = vr.name
          destination    = r.destination
          next_hop       = r.next_hop
          interface      = r.interface
          type           = r.type
          admin_distance = r.admin_distance
          route_table    = r.route_table
        }
      ]
    }
  ]

  pa_virtual_routers = {
    for x in local.virtual_routers_config : x.name => x
  }

  route_map = flatten([
    for x in local.virtual_routers_config : x.routes
  ])

  pa_virtual_routers_routetable = {
    for r in local.route_map : "${r.name}${r.virtual_router}" => r
  }

}


