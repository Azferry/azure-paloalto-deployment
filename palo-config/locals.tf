
locals {
  builtin_library_path = "lib"
  pa_hostname          = var.pa_hostname
  pa_sys_timezone      = var.pa_sys_timezone
  template_file_vars = {
    nic_trust        = "ethernet1/2"
    nic_untrust      = "ethernet1/1"
    vr_untrust_name  = "untrust-vr"
    vr_trust_name    = "trust-vr"
    zone_trust       = "trust-zone"
    zone_untrust     = "untrust-zone"
    ip_gw_sn_trust   = cidrhost(data.azurerm_subnet.az_sn_trust.address_prefix, 1)
    ip_gw_sn_untrust = cidrhost(data.azurerm_subnet.az_sn_untrust.address_prefix, 1)
    cidr_sn_trust    = data.azurerm_subnet.az_sn_trust.address_prefixes[0]
    cidr_sn_untrust  = data.azurerm_subnet.az_sn_untrust.address_prefixes[0]
  }
}
