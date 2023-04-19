/*
PA Create zones
*/
resource "panos_zone" "pa_zones" {
  for_each       = local.pa_zones
  name           = each.value.name
  mode           = each.value.mode
  interfaces     = each.value.interfaces
  enable_user_id = each.value.enable_user_id

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    panos_general_settings.pa,
    panos_ethernet_interface.pa_interface
  ]
}

/*
PA management profiles
*/
resource "panos_management_profile" "pa_mgt_policy" {
  for_each                   = local.pa_interfaces_management_profiles
  name                       = each.value.name
  ping                       = each.value.ping
  telnet                     = each.value.telnet
  ssh                        = each.value.ssh
  http                       = each.value.http
  http_ocsp                  = each.value.http_ocsp
  https                      = each.value.https
  snmp                       = each.value.snmp
  response_pages             = each.value.response_pages
  userid_service             = each.value.userid_service
  userid_syslog_listener_ssl = each.value.userid_syslog_listener_ssl
  userid_syslog_listener_udp = each.value.userid_syslog_listener_udp
  permitted_ips              = each.value.permitted_ips # list
  
  lifecycle {
    create_before_destroy = true
  }
}


/*
PA Tags
*/
resource "panos_administrative_tag" "pa_tags" {
  for_each = local.pa_tags
  name     = each.value.name
  color    = each.value.color
  comment  = "${each.value.comment} - Cr By Terraform"
  depends_on = [
    panos_general_settings.pa,
    panos_ethernet_interface.pa_interface
  ]
  lifecycle {
    create_before_destroy = true
  }
}


/*
PA Dynamic Address Groups
*/
resource "panos_address_group" "pa_addr_groups" {
  for_each      = local.pa_dynaddrgrp
  name          = each.value.name
  tags          = each.value.tags
  description   = "${each.value.description} - Cr By Terraform"
  dynamic_match = each.value.dynamic_match

  depends_on = [
    panos_administrative_tag.pa_tags
  ]

  lifecycle {
    create_before_destroy = true
  }
}
