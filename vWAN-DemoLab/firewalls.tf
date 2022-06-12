# Firewall 
resource "azurerm_firewall" "region1-fw01" {
  name                = "${var.region1}-fw01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1-rg1.name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.region1-vhub1.id
    public_ip_count = 1
  }
}
resource "azurerm_firewall" "region2-fw01" {
  name                = "${var.region2}-fw01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.region2-rg1.name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.region2-vhub1.id
    public_ip_count = 1
  }
}