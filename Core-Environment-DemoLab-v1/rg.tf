data "azurerm_client_config" "current" {}
# Resource Groups
resource "azurerm_resource_group" "rg-ide" {
  for_each = var.regions
  name     = "rg-${each.value.code}-ide"
  location = each.value.region
  tags     = { environment = "identity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-sec" {
  for_each = var.regions
  name     = "rg-${each.value.code}-sec"
  location = each.value.region
  tags     = { environment = "security", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-con" {
  for_each = var.regions
  name     = "rg-${each.value.code}-con"
  location = each.value.region
  tags     = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-man" {
  for_each = var.regions
  name     = "rg-${each.value.code}-man"
  location = each.value.region
  tags     = { environment = "management", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-log" {
  for_each = var.regions
  name     = "rg-${each.value.code}-log"
  location = each.value.region
  tags     = { environment = "logging", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-aut" {
  for_each = var.regions
  name     = "rg-${each.value.code}-aut"
  location = each.value.region
  tags     = { environment = "automation", region = each.value.code, tfcreated = "true" }
}
resource "azurerm_resource_group" "rg-avd" {
  for_each = var.regions
  name     = "rg-${each.value.code}-avd"
  location = each.value.region
  tags     = { environment = "avd", region = each.value.code, tfcreated = "true" }
}