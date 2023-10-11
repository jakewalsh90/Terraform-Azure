# VNets
resource "azurerm_virtual_network" "management" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-man-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 8)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_virtual_hub_connection" "management" {
  for_each                  = var.regions
  name                      = "${each.value.code}-management-to-${each.value.code}-hub"
  virtual_hub_id            = azurerm_virtual_hub.hub1[each.key].id
  remote_virtual_network_id = azurerm_virtual_network.management[each.key].id
  internet_security_enabled = true
}
resource "azurerm_virtual_network" "identity" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-ide-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 9)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_virtual_hub_connection" "identity" {
  for_each                  = var.regions
  name                      = "${each.value.code}-identity-to-${each.value.code}-hub"
  virtual_hub_id            = azurerm_virtual_hub.hub1[each.key].id
  remote_virtual_network_id = azurerm_virtual_network.identity[each.key].id
  internet_security_enabled = true
}
resource "azurerm_virtual_network_peering" "management-to-identity" {
  for_each                     = var.regions
  name                         = "${each.value.code}-identity-to-${each.value.code}-management"
  resource_group_name          = azurerm_resource_group.rg-con[each.key].name
  virtual_network_name         = azurerm_virtual_network.identity[each.key].name
  remote_virtual_network_id    = azurerm_virtual_network.management[each.key].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_subnet.identity1, azurerm_subnet.identity2, azurerm_subnet.management1, azurerm_subnet.management2]

}
resource "azurerm_virtual_network_peering" "identity-to-management" {
  for_each                     = var.regions
  name                         = "${each.value.code}-management-to-${each.value.code}-identity"
  resource_group_name          = azurerm_resource_group.rg-con[each.key].name
  virtual_network_name         = azurerm_virtual_network.management[each.key].name
  remote_virtual_network_id    = azurerm_virtual_network.identity[each.key].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_subnet.identity1, azurerm_subnet.identity2, azurerm_subnet.management1, azurerm_subnet.management2]
}
resource "azurerm_virtual_network" "avd1" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-avd-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 10)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_virtual_hub_connection" "avd1" {
  for_each                  = var.regions
  name                      = "${each.value.code}-avd1-to-${each.value.code}-hub"
  virtual_hub_id            = azurerm_virtual_hub.hub1[each.key].id
  remote_virtual_network_id = azurerm_virtual_network.avd1[each.key].id
  internet_security_enabled = true
}
resource "azurerm_virtual_network" "avd2" {
  for_each            = var.regions
  name                = "vnet-${each.value.code}-avd-02"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  address_space       = [cidrsubnet("${each.value.cidr}", 5, 11)]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_virtual_hub_connection" "avd2" {
  for_each                  = var.regions
  name                      = "${each.value.code}-avd2-to-${each.value.code}-hub"
  virtual_hub_id            = azurerm_virtual_hub.hub1[each.key].id
  remote_virtual_network_id = azurerm_virtual_network.avd2[each.key].id
  internet_security_enabled = true
}