#Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.79.0"
    }
  }
}
provider "azurerm" {
  features {
  }
}
