# Virtual WAN
resource "azurerm_virtual_wan" "virtual-wan1" {
  name                = "virtualwan-${var.regions.region1.code}-01"
  resource_group_name = azurerm_resource_group.rg-con["region1"].name
  location            = var.regions.region1.region

  # Configuration 
  office365_local_breakout_category = "OptimizeAndAllow"

  tags = { environment = "connectivity", region = var.regions.region1.code, tfcreated = "true" }
}
# # Virtual WAN Hubs
# resource "azurerm_virtual_hub" "hub1" {
#   for_each            = var.regions
#   name                = "hub-${each.value.code}-01"
#   resource_group_name = azurerm_resource_group.rg-con[each.key].name
#   location            = each.value.region
#   virtual_wan_id      = azurerm_virtual_wan.virtual-wan1.id
#   address_prefix      = cidrsubnet("${each.value.cidr}", 2, 0)

#   sku = "Standard"

#   tags = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
# }