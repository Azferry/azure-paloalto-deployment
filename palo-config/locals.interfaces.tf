/*
PA Interface JSON Import
*/
locals {
  interface_definitions_json = tolist(fileset(local.builtin_library_path, "**/interface_*.{json,json.tftpl}"))

  interface_definitions_dataset_from_json = {
    for filepath in local.interface_definitions_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  }

  interface_definitions_map_from_json = {
    for key, value in local.interface_definitions_dataset_from_json :
    keys(value)[0] => values(value)[0]
  }
}

/*
PA Interface management profiles
*/
locals {

  interfaces_management_profiles = [
    for x in local.interfaces : {
      name                       = "${replace(x.name, "/", "")}-mg"
      ping                       = x.management_profile.ping
      telnet                     = x.management_profile.telnet
      ssh                        = x.management_profile.ssh
      http                       = x.management_profile.http
      http_ocsp                  = x.management_profile.http_ocsp
      https                      = x.management_profile.https
      snmp                       = x.management_profile.snmp
      response_pages             = x.management_profile.response_pages
      userid_service             = x.management_profile.userid_service
      userid_syslog_listener_ssl = x.management_profile.userid_syslog_listener_ssl
      userid_syslog_listener_udp = x.management_profile.userid_syslog_listener_udp
      permitted_ips              = x.management_profile.permitted_ips # list
    }
  ]

  pa_interfaces_management_profiles = {
    for x in local.interfaces_management_profiles : x.name => x
  }

}
/*
PA Virtual Router configuration
*/
locals {
  interfaces = [for v in local.interface_definitions_map_from_json : v]

  pa_interfaces = {
    for x in local.interfaces : x.name => merge(x, {
      management_profile = "${replace(x.name, "/", "")}-mg"
    })
  }
}
