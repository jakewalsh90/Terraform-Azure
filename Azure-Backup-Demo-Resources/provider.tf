terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.24.0"
    }
        random = {
      source = "hashicorp/random"
      version = "3.7.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}