# Public IPs
resource "random_id" "dns-name" {
  byte_length = 4
}
resource "azurerm_public_ip" "region1-fwpip" {
  name                = "pip-fw-${var.region1}-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-${var.region1code}-${random_id.dns-name.hex}"
}
resource "azurerm_public_ip" "region1-fwmanpip" {
  name                = "pip-fwman-${var.region1}-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "region2-fwpip" {
  name                = "pip-fw-${var.region2}-01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-${var.region2code}-${random_id.dns-name.hex}"
}
resource "azurerm_public_ip" "region2-fwmanpip" {
  name                = "pip-fwman-${var.region2}-01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Firewalls
resource "azurerm_firewall" "region1-fw1" {
  name                = "fw-${var.region1}-01"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg1.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  threat_intel_mode   = "Off"

  ip_configuration {
    name                 = "ipconfig-fw-${var.region1}"
    subnet_id            = azurerm_subnet.region1-hub1-subnetfw.id
    public_ip_address_id = azurerm_public_ip.region1-fwpip.id
  }

  management_ip_configuration {
    name                 = "ipconfig-fwman-${var.region1}"
    subnet_id            = azurerm_subnet.region1-hub1-subnetfwman.id
    public_ip_address_id = azurerm_public_ip.region1-fwmanpip.id
  }

}
resource "azurerm_firewall" "region2-fw1" {
  name                = "fw-${var.region2}-01"
  location            = var.region2
  resource_group_name = azurerm_resource_group.rg2.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  threat_intel_mode   = "Off"

  ip_configuration {
    name                 = "ipconfig-fw-${var.region2}"
    subnet_id            = azurerm_subnet.region2-hub1-subnetfw.id
    public_ip_address_id = azurerm_public_ip.region2-fwpip.id
  }

  management_ip_configuration {
    name                 = "ipconfig-fwman-${var.region2}"
    subnet_id            = azurerm_subnet.region2-hub1-subnetfwman.id
    public_ip_address_id = azurerm_public_ip.region2-fwmanpip.id
  }

}
# Firewall Rules
resource "azurerm_firewall_network_rule_collection" "region1-outbound" {
  name                = "${var.region1}-outbound"
  azure_firewall_name = azurerm_firewall.region1-fw1.name
  resource_group_name = azurerm_resource_group.rg1.name
  priority            = 100
  action              = "Allow"
  rule {
    name                  = "${var.region1}-outbound"
    source_addresses      = [var.region1cidr]
    destination_addresses = ["*"]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
}
resource "azurerm_firewall_network_rule_collection" "region2-outbound" {
  name                = "${var.region2}-outbound"
  azure_firewall_name = azurerm_firewall.region2-fw1.name
  resource_group_name = azurerm_resource_group.rg2.name
  priority            = 100
  action              = "Allow"
  rule {
    name                  = "${var.region2}-outbound"
    source_addresses      = [var.region2cidr]
    destination_addresses = ["*"]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
}
# NAT Rules
resource "azurerm_firewall_nat_rule_collection" "region1-nat" {
  name                = "${var.region1}-nat1"
  azure_firewall_name = azurerm_firewall.region1-fw1.name
  resource_group_name = azurerm_resource_group.rg1.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "${var.region1}-nat1"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.region1-fwpip.ip_address
    ]

    translated_port = 80

    translated_address = azurerm_lb.region1-lb.frontend_ip_configuration[0].private_ip_address

    protocols = [
      "TCP",
    ]
  }
}
resource "azurerm_firewall_nat_rule_collection" "region2-nat" {
  name                = "${var.region2}-nat1"
  azure_firewall_name = azurerm_firewall.region2-fw1.name
  resource_group_name = azurerm_resource_group.rg2.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "${var.region2}-nat1"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.region2-fwpip.ip_address
    ]

    translated_port = 80

    translated_address = azurerm_lb.region2-lb.frontend_ip_configuration[0].private_ip_address

    protocols = [
      "TCP",
    ]
  }
}