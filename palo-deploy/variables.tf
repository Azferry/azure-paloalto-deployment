variable "prefix" {
  type        = string
  description = "The prefix to use for all resources in this example"
  default     = "palo"
}

variable "azure_region" {
  type        = string
  description = "The Azure region to deploy the resources into"
  default     = "eastus2"
}

variable "default_vm_username" {
  type        = string
  description = "The default username for the VM"
  default = "paloadmin"
}
variable "default_vm_userpassword" {
  type        = string
  description = "The default password for the VM"
  default = "Change-Me-007"

}
