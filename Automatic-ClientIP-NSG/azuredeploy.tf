#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
#Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
#Lab NSG
resource "azurerm_network_security_group" "Automatic-ClientIP-NSG" {
  name                = "Automatic-ClientIP-NSG"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "RDP-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.clientip.body)}/32"
    destination_address_prefix = "*"
  }
  tags = {
    Environment = var.environment_tag
  }
}