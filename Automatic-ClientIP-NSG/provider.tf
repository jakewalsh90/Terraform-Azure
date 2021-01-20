#Providers
terraform {
  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilise
      source = "hashicorp/azurerm"
      version = ">= 2.43.0"
    }
  }
}
provider "azurerm" {
  features {
    }
  }