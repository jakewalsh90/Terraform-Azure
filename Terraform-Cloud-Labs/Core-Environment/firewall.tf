# Hub Firewalls
resource "azurerm_firewall" "firewall1" {
  for_each            = var.regions
  name                = "fw-${each.value.code}-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region
  sku_tier            = "Standard"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.fwpol1[each.key].id
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.hub1[each.key].id
    public_ip_count = 1
  }

  tags = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
# Routing Intent
resource "azurerm_virtual_hub_routing_intent" "intent1" {
  for_each       = var.regions
  name           = "intent-${each.value.code}-01"
  virtual_hub_id = azurerm_virtual_hub.hub1[each.key].id
  depends_on     = [azurerm_firewall.firewall1]

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.firewall1[each.key].id
  }
  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.firewall1[each.key].id
  }
}
# Firewall Policy
resource "azurerm_firewall_policy" "fwpol1" {
  for_each            = var.regions
  name                = "fwpol-${each.value.code}-01"
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  location            = each.value.region

  tags = { environment = "connectivity", region = each.value.code, tfcreated = "true" }
}
# Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "fwrcg1" {
  for_each           = var.regions
  name               = "fwrcg-${each.value.code}-01"
  firewall_policy_id = azurerm_firewall_policy.fwpol1[each.key].id
  priority           = 100
  network_rule_collection {
    name     = "network_rules1"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}