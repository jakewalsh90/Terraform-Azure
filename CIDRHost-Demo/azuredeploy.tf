#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = "rg-${var.region1}-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
  }
}
# VNETs - Region 1
resource "azurerm_virtual_network" "region1-hub1" {
  name                = "vnet-${var.region1}-hub-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 0)]
  dns_servers         = [cidrhost("${var.region1cidr}", 4), cidrhost("${var.region1cidr}", 5)]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "region1-spoke1" {
  name                = "vnet-${var.region1}-spoke-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 1)]
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "region1-spoke2" {
  name                = "vnet-${var.region1}-spoke-02"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [cidrsubnet("${var.region1cidr}", 2, 2)]
  tags = {
    Environment = var.environment_tag
  }
}
# Subnets
resource "azurerm_subnet" "region1-hub1-subnet" {
  name                 = "snet-${var.region1}-vnet-hub-01"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-hub1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 0)]
}
resource "azurerm_subnet" "region1-spoke1-subnets" {
  count                = 8
  name                 = "snet-${var.region1}-vnet-spoke-01-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-spoke1.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, "${count.index + 8}")]
}
resource "azurerm_subnet" "region1-spoke2-subnet" {
  name                 = "snet-${var.region1}-vnet-spoke-02"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-spoke2.name
  address_prefixes     = [cidrsubnet("${var.region1cidr}", 5, 16)]
}
# Network Interface - Hub
resource "azurerm_network_interface" "hub-nic" {
  name                = "nic-in-hub-example"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.region1-hub1-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost("${var.region1cidr}", 4)
  }
}
# Network Interfaces - Spoke 1
resource "azurerm_network_interface" "spoke1-nics" {
  count               = 8
  name                = "nic-in-spoke1-example-${count.index}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.region1-spoke1-subnets[count.index].id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(join(", ", "${azurerm_subnet.region1-spoke1-subnets[count.index].address_prefixes}"), 4)
  }
}
# Network Interfaces - Spoke 2
resource "azurerm_network_interface" "spoke2-nics" {
  count               = 8
  name                = "nic-in-spoke2-example-${count.index}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.region1-spoke2-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(join(", ", "${azurerm_subnet.region1-spoke2-subnet.address_prefixes}"), "${count.index + 4}")
  }
}
# NSG Example
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.region1}-demo-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "Testing1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = cidrhost("${var.region1cidr}", 4)
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Testing2"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = cidrhost(join(", ", "${azurerm_subnet.region1-spoke1-subnets[0].address_prefixes}"), 4)
    destination_address_prefix = "*"
  }
}
# Route Table Example
resource "azurerm_route_table" "rtb-01" {
  name                = "rtb-${var.region1}-demo-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost("${var.region1cidr}", 4)
  }
}
resource "azurerm_route_table" "rtb-02" {
  name                = "rtb-${var.region1}-demo-02"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost(join(", ", "${azurerm_subnet.region1-spoke1-subnets[0].address_prefixes}"), 4)
  }
}