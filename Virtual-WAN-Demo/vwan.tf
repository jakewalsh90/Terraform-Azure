# Virtual-WAN Resources
# Virtual-WAN
resource "azurerm_virtual_wan" "Virtual-WAN1" {
  name                = "${var.lab-name}-Virtual-WAN-01"
  resource_group_name = azurerm_resource_group.region1-rg1.name
  location            = var.region1

  # Configuration 
  office365_local_breakout_category = "OptimizeAndAllow"

  tags = {
    Environment = var.environment_tag
  }
}
# Virtual-WAN Hub 1
resource "azurerm_virtual_hub" "region1-vhub1" {
  name                = "${var.region1}-Virtual-WAN-hub-01"
  resource_group_name = azurerm_resource_group.region1-rg1.name
  location            = var.region1
  virtual_wan_id      = azurerm_virtual_wan.Virtual-WAN1.id
  address_prefix      = var.Virtual-WAN-region1-hub1-prefix1

  tags = {
    Environment = var.environment_tag
  }
}
# Virtual-WAN Hub 2
resource "azurerm_virtual_hub" "region2-vhub1" {
  name                = "${var.region2}-Virtual-WAN-hub-02"
  resource_group_name = azurerm_resource_group.region2-rg1.name
  location            = var.region2
  virtual_wan_id      = azurerm_virtual_wan.Virtual-WAN1.id
  address_prefix      = var.Virtual-WAN-region2-hub1-prefix1

  tags = {
    Environment = var.environment_tag
  }
}
# Virtual-WAN Hub Connection 1
resource "azurerm_virtual_hub_connection" "region1-connection1" {
  name                      = "${var.region1}-conn-vnet1-to-Virtual-WAN-hub"
  virtual_hub_id            = azurerm_virtual_hub.region1-vhub1.id
  remote_virtual_network_id = azurerm_virtual_network.region1-vnet1.id
}
# Virtual-WAN Hub Connection 2
resource "azurerm_virtual_hub_connection" "region2-connection1" {
  name                      = "${var.region2}-conn-vnet1-to-Virtual-WAN-hub"
  virtual_hub_id            = azurerm_virtual_hub.region2-vhub1.id
  remote_virtual_network_id = azurerm_virtual_network.region2-vnet1.id
}