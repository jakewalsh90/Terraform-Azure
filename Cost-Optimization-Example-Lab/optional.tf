# Azure Bastion
# Public IP
resource "azurerm_public_ip" "pip-bastion" {
  count               = var.bastion ? 1 : 0
  name                = "pip-${var.region1code}-bst"
  resource_group_name = azurerm_resource_group.rg-sec.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-bst${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-security"
  }
}
# Public IP 2 - Unused
resource "azurerm_public_ip" "pip-bastion2" {
  count               = var.bastion ? 1 : 0
  name                = "pip-${var.region1code}-bst2"
  resource_group_name = azurerm_resource_group.rg-sec.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-bst2${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-security"
  }
}
# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  count               = var.bastion ? 1 : 0
  name                = "bst-${var.region1code}"
  resource_group_name = azurerm_resource_group.rg-sec.name
  location            = var.region1
  depends_on = [
    azurerm_public_ip.pip-bastion[0],
    azurerm_subnet_network_security_group_association.nsg-hub1-subnets,
    azurerm_subnet_network_security_group_association.nsg-spoke1-subnets,
  ]

  ip_configuration {
    name                 = "bst-${var.region1code}"
    subnet_id            = azurerm_subnet.region1-hub1-AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.pip-bastion[0].id
  }

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-security"
  }
}
# AVD Elements
# Resource Group
resource "azurerm_resource_group" "rg-avd" {
  count    = var.avd ? 1 : 0
  name     = "rg-baselabv2-${var.region1code}-avd-01"
  location = var.region1

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-avd"
  }
}
# Host Pools
resource "azurerm_virtual_desktop_host_pool" "hp1" {
  count               = var.avd ? 1 : 0
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-avd[0].name

  name                     = "multi-user-pool"
  friendly_name            = "multi-user-pool"
  validate_environment     = false
  start_vm_on_connect      = false
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "1 to many Host Pool"
  type                     = "Pooled"
  maximum_sessions_allowed = 50
  load_balancer_type       = "DepthFirst"
}
resource "azurerm_virtual_desktop_host_pool" "hp2" {
  count               = var.avd ? 1 : 0
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-avd[0].name

  name                             = "single-user-pool"
  friendly_name                    = "single-user-pool"
  validate_environment             = false
  start_vm_on_connect              = false
  custom_rdp_properties            = "audiocapturemode:i:1;audiomode:i:0;"
  description                      = "1 to 1 Host Pool"
  type                             = "Personal"
  maximum_sessions_allowed         = 999999
  load_balancer_type               = "Persistent"
  personal_desktop_assignment_type = "Automatic"
}
# App Groups
resource "azurerm_virtual_desktop_application_group" "appgroup1" {
  count               = var.avd ? 1 : 0
  name                = "app-group1-multi"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-avd[0].name

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.hp1[0].id
  friendly_name = "Multi User Desktop"
  description   = "Multi User Desktop Session"
}
resource "azurerm_virtual_desktop_application_group" "appgroup2" {
  count               = var.avd ? 1 : 0
  name                = "app-group2-single"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-avd[0].name

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.hp2[0].id
  friendly_name = "Single User Desktop"
  description   = "Single User Desktop Session"
}
# Workspaces 
resource "azurerm_virtual_desktop_workspace" "demo-avd-workspace" {
  count               = var.avd ? 1 : 0
  name                = "demolab-workspace"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-avd[0].name

  friendly_name = "demo-avd-workspace"
  description   = "Demo AVD Workspace"
}
# App Group to Workspace Assignment
resource "azurerm_virtual_desktop_workspace_application_group_association" "multi-user" {
  count                = var.avd ? 1 : 0
  workspace_id         = azurerm_virtual_desktop_workspace.demo-avd-workspace[0].id
  application_group_id = azurerm_virtual_desktop_application_group.appgroup1[0].id
}
resource "azurerm_virtual_desktop_workspace_application_group_association" "single-user" {
  count                = var.avd ? 1 : 0
  workspace_id         = azurerm_virtual_desktop_workspace.demo-avd-workspace[0].id
  application_group_id = azurerm_virtual_desktop_application_group.appgroup2[0].id
}
resource "azurerm_shared_image_gallery" "sig" {
  count               = var.avd ? 1 : 0
  name                = "sig${var.region1code}avd01"
  resource_group_name = azurerm_resource_group.rg-avd[0].name
  location            = var.region1
  description         = "Shared Images for AVD"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-avd"
  }
}
# Virtual Network Gateway
# Public IP
resource "azurerm_public_ip" "pip-gateway" {
  count               = var.vng ? 1 : 0
  name                = "pip-${var.region1code}-vng"
  resource_group_name = azurerm_resource_group.rg-con.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-vng${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
  }
}
# Public IP - Unused
resource "azurerm_public_ip" "pip-gateway2" {
  count               = var.vng ? 1 : 0
  name                = "pip-${var.region1code}-vng2"
  resource_group_name = azurerm_resource_group.rg-con.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-vng2${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
  }
}
# Gateway
resource "azurerm_virtual_network_gateway" "gateway" {
  count               = var.vng ? 1 : 0
  name                = "vng-${var.region1code}"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg-con.name
  depends_on = [
    azurerm_public_ip.pip-gateway[0],
    azurerm_subnet_network_security_group_association.nsg-hub1-subnets,
    azurerm_subnet_network_security_group_association.nsg-spoke1-subnets,
  ]

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.region1-hub1-GatewaySubnet.id
  }
}
# Azure Firewall
# Public IPs
resource "azurerm_public_ip" "pip-firewall" {
  count               = var.azfw ? 1 : 0
  name                = "pip-${var.region1code}-azfw"
  resource_group_name = azurerm_resource_group.rg-con.name
  location            = var.region1
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-azfw${count.index}-${random_id.dns-name.hex}"

  tags = {
    Environment = var.environment_tag
    Function    = "BaseLabv2-connectivity"
  }
}
# Firewall
resource "azurerm_firewall" "firewall" {
  count               = var.azfw ? 1 : 0
  name                = "azfw-${var.region1code}"
  resource_group_name = azurerm_resource_group.rg-con.name
  location            = var.region1
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  depends_on = [
    azurerm_public_ip.pip-firewall[0],
    azurerm_subnet_network_security_group_association.nsg-hub1-subnets,
    azurerm_subnet_network_security_group_association.nsg-spoke1-subnets,
  ]

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.region1-hub1-AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.pip-firewall[0].id
  }

}