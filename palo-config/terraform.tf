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
  hostname = var.auth_pa_hostname
  username = var.auth_pa_username
  password = var.auth_pa_password

  /* If you want to use a JSON file for the provider configuration, 
  uncomment the following line and comment out the above 3 lines. */
  # json_config_file = "../panos-creds.json"
}

provider "azurerm" {
  features {}
}
