terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.29.0"
    }
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.11.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
  }

  required_version = ">= 0.15.1"
}

provider "panos" {
  hostname = "paloalto01-nic-mgt-pip.eastus.cloudapp.azure.com"
  username = "paloadmin"
  password = "Change-Me-007"
  # json_config_file = "../panos-creds.json"
}

provider "azurerm" {
  features {}
}
