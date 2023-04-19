variable "vnet_name" {
  type        = string
  description = "Name of hub vnet"
}


variable "subscription_id" {
  type        = string
  description = "Subscription ID"
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id)) || var.subscription_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "pa_hostname" {
  type        = string
  description = "Host name of the pa device"
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
