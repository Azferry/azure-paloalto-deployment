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
