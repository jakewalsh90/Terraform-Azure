#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = var.azure-rg-2
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
resource "azurerm_resource_group" "rg3" {
  name     = var.azure-rg-3
  location = var.loc2
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
#VNETs
resource "azurerm_virtual_network" "region1-vnet1-hub1" {
  name                = var.region1-vnet1-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region1-vnet2-spoke1" {
  name                = var.region1-vnet2-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region2-vnet1-hub1" {
  name                = var.region2-vnet1-name
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg3.name
  address_space       = [var.region2-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region2-vnet2-spoke1" {
  name                = var.region2-vnet2-name
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg3.name
  address_space       = [var.region2-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}