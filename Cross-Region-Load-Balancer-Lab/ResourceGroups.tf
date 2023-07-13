# Resource Groups
resource "azurerm_resource_group" "rg-sec" {
  name     = "rg-${var.regions.region1.location}-sec"
  location = var.regions.region1.location
}
resource "azurerm_resource_group" "rg-con" {
  for_each = var.regions
  name     = "rg-${each.value.location}-con"
  location = each.value.location
}
resource "azurerm_resource_group" "rg-host" {
  for_each = var.regions
  name     = "rg-${each.value.location}-host"
  location = each.value.location
}