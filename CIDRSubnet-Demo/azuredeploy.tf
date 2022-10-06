#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = "rg-${var.region1}-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
# VNETs - Region 1
resource "azurerm_virtual_network" "region1-hub1" {
  name                = "vnet-${var.region1}-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "region1-spoke1" {
  name                = "vnet-${var.region1}-spoke-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 1)]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "region1-spoke2" {
  name                = "vnet-${var.region1}-spoke-02"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 2)]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "region1-spoke3" {
  name                = "vnet-${var.region1}-spoke-03"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 3)]
  tags = {
    Environment = var.environment_tag
  }
}
# Subnets
resource "azurerm_subnet" "region1-hub1-subnets" {
  count                = 8
  name                 = "snet-${var.region1}-vnet-hub-01-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index}")]
}
resource "azurerm_subnet" "region1-spoke1-subnets" {
  count                = 8
  name                 = "snet-${var.region1}-vnet-spoke-01-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-spoke1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 8}")]
}
resource "azurerm_subnet" "region1-spoke2-subnets" {
  count                = 8
  name                 = "snet-${var.region1}-vnet-spoke-02-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-spoke2.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 16}")]
}
resource "azurerm_subnet" "region1-spoke3-subnets" {
  count                = 8
  name                 = "snet-${var.region1}-vnet-spoke-02-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-spoke3.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 24}")]
}