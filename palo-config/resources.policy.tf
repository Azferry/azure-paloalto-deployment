
/*
PA NAT rule
*/
resource "panos_nat_rule_group" "pa_nat" {
  for_each           = local.pa_nat_policy
  position_keyword   = null
  position_reference = null
  rule {
    name          = each.value.name
    audit_comment = "Cr By. Terraform"
    description   = each.value.description
    tags          = each.value.tags
    original_packet {
      source_zones          = each.value.original_packet.source_zones
      destination_zone      = each.value.original_packet.destination_zone
      destination_interface = each.value.original_packet.destination_interface
      service               = each.value.original_packet.service
      source_addresses      = each.value.original_packet.source_addresses
      destination_addresses = each.value.original_packet.destination_addresses
    }
    translated_packet {
      source {

        dynamic "static_ip" {
          for_each = each.value.translated_packet.source.static_ip
          content {
            translated_address = static_ip.value.translated_address
            bi_directional     = static_ip.value.bi_directional
          }
        }

        dynamic "dynamic_ip_and_port" {
          for_each = each.value.translated_packet.source.dynamic_ip_and_port
          content {
            interface_address {
              interface  = dynamic_ip_and_port.value.interface
              ip_address = dynamic_ip_and_port.value.ip_address
            }
          }
        }

      }
      destination {

      }
    }
  }
  depends_on = [
    panos_zone.pa_zones
  ]
  lifecycle {
    create_before_destroy = true
  }
}

/*
PA Security Policy
*/
resource "panos_security_rule_group" "pa_sec" {
  for_each = local.pa_sec_policy
  rule {
    name                  = each.value.name
    description           = each.value.description
    audit_comment         = each.value.audit_comment
    source_zones          = each.value.source_zones
    source_addresses      = each.value.source_addresses
    source_users          = each.value.source_users
    destination_zones     = each.value.destination_zones
    destination_addresses = each.value.destination_addresses
    applications          = each.value.applications
    services              = each.value.services
    categories            = each.value.categories
    action                = each.value.action
    log_end               = each.value.log_end
    log_start             = each.value.log_start
    disabled              = each.value.disabled
    tags                  = each.value.tags
    type                  = each.value.type
  }
  depends_on = [
    panos_nat_rule_group.pa_nat,
    panos_administrative_tag.pa_tags
  ]
  lifecycle {
    create_before_destroy = true
  }
}
