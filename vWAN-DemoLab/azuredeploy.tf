# Resource Groups vWAN
resource "azurerm_resource_group" "rg1" {
  name     = "${var.lab-name}-vwan-rg-01"
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = "${var.lab-name}-vwan-rg-02"
  location = var.loc2
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
# Resource Groups Local Branches
resource "azurerm_resource_group" "rg3" {
  name     = "${var.lab-name}-localbranch1-rg-01"
  location = var.loc3
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
resource "azurerm_resource_group" "rg4" {
  name     = "${var.lab-name}-localbranch2-rg-01"
  location = var.loc4
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
# Local Site VNET 1 (to simulate branch offices)
resource "azurerm_virtual_network" "localbranch1-vnet1" {
  name                = "${var.lab-name}-localbranch1-vnet-01"
  location            = var.loc3
  resource_group_name = azurerm_resource_group.rg3.name
  address_space       = [var.local1-vnet1-address-space]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_subnet" "local-branch1-vnet1-snet1" {
  name                 = "${var.lab-name}-localbranch1-vnet-01-subnet-01"
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.localbranch1-vnet1.name
  address_prefixes     = [var.local1-vnet1-snet1-range]
}
# Local Site VNET 2 (to simulate branch offices)
resource "azurerm_virtual_network" "localbranch2-vnet1" {
  name                = "${var.lab-name}-localbranch2-vnet-01"
  location            = var.loc3
  resource_group_name = azurerm_resource_group.rg4.name
  address_space       = [var.local2-vnet1-address-space]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_subnet" "local-branch2-vnet1-snet1" {
  name                 = "${var.lab-name}-localbranch2-vnet-01-subnet-01"
  resource_group_name  = azurerm_resource_group.rg4.name
  virtual_network_name = azurerm_virtual_network.localbranch2-vnet1.name
  address_prefixes     = [var.local2-vnet1-snet1-range]
}
