# Azure Bastion
# Public IPs
resource "azurerm_public_ip" "region1-bastion-pip" {
  name                = "${var.region1}-bastion-pip"
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1-rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_public_ip" "region2-bastion-pip" {
  name                = "${var.region2}-bastion-pip"
  location            = var.region2
  resource_group_name = azurerm_resource_group.region2-rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Environment = var.environment_tag
  }
}
# Azure Bastion
resource "azurerm_bastion_host" "region1-bastion" {
  name                = "${var.region1}-bastion"
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1-rg1.name
  ip_configuration {
    name                 = "${var.region1}-bastion-ipconfig"
    public_ip_address_id = azurerm_public_ip.region1-bastion-pip.id
    subnet_id            = azurerm_subnet.region1-bastion-snet.id
  }
}
resource "azurerm_bastion_host" "region2-bastion" {
  name                = "${var.region2}-bastion"
  location            = var.region2
  resource_group_name = azurerm_resource_group.region2-rg1.name
  ip_configuration {
    name                 = "${var.region2}-bastion-ipconfig"
    public_ip_address_id = azurerm_public_ip.region2-bastion-pip.id
    subnet_id            = azurerm_subnet.region2-bastion-snet.id
  }
}