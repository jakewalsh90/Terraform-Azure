#Providers
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.43.0"
    }
  }
}
provider "azurerm" {
  features {
    }
  }
