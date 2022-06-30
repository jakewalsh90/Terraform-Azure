#Terraform
 terraform {
  required_version = ">= 0.11" 
 backend "azurerm" {
  storage_account_name = "__terraformstorageaccount__"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
	access_key  ="__storagekey__"
  features{}
	}
	}
#Providers
terraform {
  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilise
      source  = "hashicorp/azurerm"
      version = ">= 3.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.1"
    }
  }
}
provider "azurerm" {
  # Configuration options
    features {
      key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}