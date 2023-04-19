variable "vnet_name" {
  type        = string
  description = "Name of hub virtual network"
  default     = "paloalto01-vn"
}

variable "pa_hostname" {
  type        = string
  description = "Host name of the pa device"
  default = "paloalto01-vm"
}

variable "pa_sys_timezone" {
  type        = string
  description = "Timezone for the PA device"
  default     = "US/Eastern"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "paloalto01-rg"
}

variable "trust_sn_name" {
  type        = string
  description = "Name of the trust subnet"
  default     = "palo-trust-sn01"
}

variable "untrust_sn_name" {
  type        = string
  description = "Name of the untrust subnet"
  default     = "palo-untrust-sn01"
}

variable "mgt_sn_name" {
  type        = string
  description = "Name of the management subnet"
  default     = "palo-mgt-sn01"
}

variable "auth_pa_hostname" {
  type        = string
  description = "Host name of the auth pa device"
  default = "paloalto01-nic-mgt-pip.eastus.cloudapp.azure.com"
}

variable "auth_pa_username" {
  type        = string
  description = "Username for the auth pa device"
  default = "paloadmin"
}

variable "auth_pa_password" {
  type        = string
  description = "Password for the auth pa device"
  default = "Change-Me-007"
}
