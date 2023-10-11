# Virtual WAN
resource "azurerm_virtual_wan" "virtual-wan1" {
  name                = "vwan-${var.regions.region1.code}-01"
  resource_group_name = azurerm_resource_group.rg-con["region1"].name
  location            = var.regions.region1.region
  # Configuration 
  office365_local_breakout_category = "OptimizeAndAllow"
  tags                              = { environment = "connectivity", region = var.regions.region1.code, tfcreated = "true" }
}
# Virtual WAN Hubs
resource "azurerm_virtual_hub" "hub1" {
  for_each            = var.regions
  name                = "hub-${each.value.code}-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  virtual_wan_id      = azurerm_virtual_wan.virtual-wan1.id
  address_prefix      = cidrsubnet("${each.value.cidr}", 2, 0)
  sku                 = "Standard"
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
# VPN Gateways
resource "azurerm_vpn_gateway" "vpngw" {
  for_each            = var.regions
  name                = "gw-${each.value.code}-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  virtual_hub_id      = azurerm_virtual_hub.hub1[each.key].id
  depends_on          = [azurerm_firewall.firewall1]
  tags                = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
# P2S Config
resource "azurerm_vpn_server_configuration" "p2svpn1" {
  name                     = "vpnconf-${var.regions.region1.region}-p2s-01"
  resource_group_name      = azurerm_resource_group.rg-con["region1"].name
  location                 = var.regions.region1.region
  vpn_authentication_types = ["AAD"]
  depends_on               = [azurerm_firewall.firewall1]
  azure_active_directory_authentication {
    audience = var.vpn_app_id
    tenant   = "https://login.microsoftonline.com/${var.tenant_id}"
    issuer   = "https://sts.windows.net/${var.tenant_id}/"
  }
  tags = { environment = "connectivity", region = var.regions.region1.region, tfcreated = "true" }
}
# P2S Gateway
resource "azurerm_point_to_site_vpn_gateway" "p2svpngw" {
  for_each                    = var.regions
  name                        = "gw-${each.value.code}-p2s-01"
  resource_group_name         = azurerm_resource_group.rg-con[each.key].name
  location                    = each.value.region
  virtual_hub_id              = azurerm_virtual_hub.hub1[each.key].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2svpn1.id
  scale_unit                  = 1
  depends_on                  = [azurerm_firewall.firewall1]
  connection_configuration {
    name = "conn-${each.value.code}-p2s-01"
    vpn_client_address_pool {
      address_prefixes = [
        cidrsubnet("${each.value.cidr}", 5, 30),
      ]
    }
  }
  tags = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}