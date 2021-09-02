# Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = "${var.lab-name}-rg-01"
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = "${var.lab-name}-rg-02"
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
# vWAN
resource "azurerm_virtual_wan" "vwan1" {
  name                = "${var.lab-name}-vWAN-01"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1

  # Configuration 
  office365_local_breakout_category = "OptimizeAndAllow"

  tags = {
    Environment = var.environment_tag
  }

}
# vWAN Hub 1
resource "azurerm_virtual_hub" "vhub1" {
  name                = "${var.lab-name}-vWAN-hub-01"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  address_prefix      = var.vwan-loc1-hub1-prefix1

  tags = {
    Environment = var.environment_tag
  }

}
# vWAN Hub 2
resource "azurerm_virtual_hub" "vhub2" {
  name                = "${var.lab-name}-vWAN-hub-02"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.loc2
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  address_prefix      = var.vwan-loc2-hub1-prefix1

  tags = {
    Environment = var.environment_tag
  }

}