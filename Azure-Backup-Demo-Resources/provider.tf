terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.4.0"
    }
        random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}