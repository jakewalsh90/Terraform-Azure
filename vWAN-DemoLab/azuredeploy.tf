#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
#vWAN
resource "azurerm_virtual_wan" "vwan1" {
  name                = "${var.lab-name}-vWAN-01"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
}

resource "azurerm_virtual_hub" "vhub1" {
  name                = "${var.lab-name}-vWAN-hub-01"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  address_prefix      = var.vwan1-hub1-prefix1
}