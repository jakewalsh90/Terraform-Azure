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
resource "azurerm_subnet" "avd1" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-avd-01"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 20)]
  virtual_network_name = azurerm_virtual_network.avd1[each.key].name
}
resource "azurerm_subnet" "avd2" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-avd-02"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 21)]
  virtual_network_name = azurerm_virtual_network.avd1[each.key].name
}
resource "azurerm_subnet" "avd3" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-avd-03"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 22)]
  virtual_network_name = azurerm_virtual_network.avd2[each.key].name
}
resource "azurerm_subnet" "avd4" {
  for_each             = var.regions
  name                 = "snet-${each.value.code}-avd-04"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  address_prefixes     = [cidrsubnet("${each.value.cidr}", 6, 23)]
  virtual_network_name = azurerm_virtual_network.avd2[each.key].name
}