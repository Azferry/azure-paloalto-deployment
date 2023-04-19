/*
PA Genearl Device Configuration
*/
resource "panos_general_settings" "pa" {
  hostname = local.pa_hostname
  timezone = local.pa_sys_timezone
  lifecycle {
    create_before_destroy = true
  }
}

/*
PA Configure Interfaces
*/
resource "panos_ethernet_interface" "pa_interface" {
  for_each                  = local.pa_interfaces
  name                      = each.value.name
  vsys                      = each.value.vsys
  mode                      = each.value.mode
  enable_dhcp               = each.value.enable_dhcp
  dhcp_default_route_metric = each.value.dhcp_default_route_metric
  management_profile        = each.value.management_profile
  comment                   = each.value.comment
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    panos_general_settings.pa,
    panos_management_profile.pa_mgt_policy
  ]
}


/*
PA Deploy Virtual routers
*/
resource "panos_virtual_router" "pa_vr" {
  for_each    = local.pa_virtual_routers
  name        = each.value.name
  static_dist = each.value.static_dist
  interfaces  = each.value.interfaces
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    panos_general_settings.pa,
    panos_ethernet_interface.pa_interface
  ]
}

/*
PA add routes to virtual routers
*/
resource "panos_static_route_ipv4" "pa_vr_route" {
  for_each       = local.pa_virtual_routers_routetable
  name           = each.value.name
  virtual_router = each.value.virtual_router
  destination    = each.value.destination
  next_hop       = each.value.next_hop
  interface      = each.value.interface
  type           = each.value.type
  admin_distance = each.value.admin_distance
  route_table    = each.value.route_table
  bfd_profile    = "None"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    panos_virtual_router.pa_vr,
    panos_ethernet_interface.pa_interface
  ]
}

