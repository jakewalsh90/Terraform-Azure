terraform {
  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilise
      source  = "hashicorp/azurerm"
      version = ">= 3.59.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
provider "azurerm" {
  features {
  }
}