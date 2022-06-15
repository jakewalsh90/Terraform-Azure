# Firewall 
resource "azurerm_firewall" "region1-fw01" {
  name                = "${var.region1}-fw01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1-rg1.name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.fw-pol01.id
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.region1-vhub1.id
    public_ip_count = 1
  }
}
resource "azurerm_firewall" "region2-fw01" {
  name                = "${var.region2}-fw01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.region2-rg1.name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.fw-pol01.id
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.region2-vhub1.id
    public_ip_count = 1
  }
}
#Firewall Policy
resource "azurerm_firewall_policy" "fw-pol01" {
  name                = "fw-pol01"
  resource_group_name = azurerm_resource_group.region1-rg1.name
  location            = var.region1
}
# Firewall Policy Rules
resource "azurerm_firewall_policy_rule_collection_group" "region1-policy1" {
  name               = "fw-pol01-rules"
  firewall_policy_id = azurerm_firewall_policy.fw-pol01.id
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