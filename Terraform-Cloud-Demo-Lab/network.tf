# VNets
resource "azurerm_virtual_network" "management" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-man-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 8)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_virtual_network" "identity" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-ide-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 9)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
# Subnets
resource "azurerm_subnet" "management1" {
  for_each             = var.regions
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 16)]
  virtual_network_name = azurerm_virtual_network.management[each.key].name
}
resource "azurerm_subnet" "management2" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-man-01"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 17)]
  virtual_network_name = azurerm_virtual_network.management[each.key].name
}
resource "azurerm_subnet" "identity1" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-ide-01"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 18)]
  virtual_network_name = azurerm_virtual_network.identity[each.key].name
}
resource "azurerm_subnet" "identity2" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-ide-02"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 19)]
  virtual_network_name = azurerm_virtual_network.identity[each.key].name
}