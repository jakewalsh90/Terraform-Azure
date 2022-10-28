# LB PIPs
resource "azurerm_public_ip" "region1-lbpip" {
  name                = "${var.region1}-lb-pip"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "region2-lbpip" {
  name                = "${var.region2}-lb-pip"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# LBs
resource "azurerm_lb" "region1-lb" {
  name                = "${var.region1}-lb"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "Standard"
  depends_on = [
    azurerm_public_ip.region1-lbpip
  ]

  frontend_ip_configuration {
    name                 = "${var.region1}-lb-pip"
    public_ip_address_id = azurerm_public_ip.region1-lbpip.id
  }
}
resource "azurerm_lb" "region2-lb" {
  name                = "${var.region2}-lb"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  sku                 = "Standard"
  depends_on = [
    azurerm_public_ip.region1-lbpip
  ]

  frontend_ip_configuration {
    name                 = "${var.region2}-lb-pip"
    public_ip_address_id = azurerm_public_ip.region2-lbpip.id
  }
}