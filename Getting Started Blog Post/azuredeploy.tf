# Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
}
# VNET
resource "azurerm_virtual_network" "region1-vnet1-hub1" {
  name                = var.region1-vnet1-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet1-address-space]
}