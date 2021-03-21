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
      source = "hashicorp/azurerm"
      version = "=2.49.0"
    }
    random = {
      source = "hashicorp/random"
      version = "=3.1.0"
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