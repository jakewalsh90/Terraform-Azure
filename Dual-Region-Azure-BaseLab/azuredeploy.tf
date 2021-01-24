#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = var.azure-rg-2
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
resource "azurerm_resource_group" "rg3" {
  name     = var.azure-rg-3
  location = var.loc2
  tags = {
    Environment = var.environment_tag
    Function = "baselabv2-resourcegroups"
  }
}
#VNETs
resource "azurerm_virtual_network" "region1-vnet1-hub1" {
  name                = var.region1-vnet1-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "10.11.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region1-vnet2-spoke1" {
  name                = var.region1-vnet2-name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "10.11.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region2-vnet1-hub1" {
  name                = var.region2-vnet1-name
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg3.name
  address_space       = [var.region2-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "10.11.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
resource "azurerm_virtual_network" "region2-vnet2-spoke1" {
  name                = var.region2-vnet2-name
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg3.name
  address_space       = [var.region2-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "10.11.1.4", "168.63.129.16", "8.8.8.8"]
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-network"
   }
}
#VNET Peerings
#Region 1 Hub-Spoke
resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "region1-vnet1-to-region1-vnet2"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.region1-vnet1-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-vnet2-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "region1-vnet2-to-region1-vnet1"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.region1-vnet2-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-vnet1-hub1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
#Region 2 Hub-Spoke
resource "azurerm_virtual_network_peering" "peer3" {
  name                      = "region2-vnet1-to-region2-vnet2"
  resource_group_name       = azurerm_resource_group.rg3.name
  virtual_network_name      = azurerm_virtual_network.region2-vnet1-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region2-vnet2-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "peer4" {
  name                      = "region2-vnet2-to-region2-vnet1"
  resource_group_name       = azurerm_resource_group.rg3.name
  virtual_network_name      = azurerm_virtual_network.region2-vnet2-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.region2-vnet1-hub1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
#Hub VNET peerings - Global peering
resource "azurerm_virtual_network_peering" "peer5" {
  name                         = "region1-vnet1-to-region2-vnet1"
  resource_group_name          = azurerm_resource_group.rg1.name
  virtual_network_name         = azurerm_virtual_network.region1-vnet1-hub1.name
  remote_virtual_network_id    = azurerm_virtual_network.region2-vnet1-hub1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit = false
}
resource "azurerm_virtual_network_peering" "peer6" {
  name                         = "region2-vnet1-to-region1-vnet1"
  resource_group_name          = azurerm_resource_group.rg3.name
  virtual_network_name         = azurerm_virtual_network.region2-vnet1-hub1.name
  remote_virtual_network_id    = azurerm_virtual_network.region1-vnet1-hub1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit = false
}
#Subnets
#Region 1
resource "azurerm_subnet" "region1-vnet1-snet1" {
  name                 = var.region1-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
  address_prefixes     = [var.region1-vnet1-snet1-range]
}
resource "azurerm_subnet" "region1-vnet1-snet2" {
  name                 = var.region1-vnet1-snet2-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
  address_prefixes     = [var.region1-vnet1-snet2-range]
}
resource "azurerm_subnet" "region1-vnet1-snet3" {
  name                 = var.region1-vnet1-snet3-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
  address_prefixes     = [var.region1-vnet1-snet3-range]
}
resource "azurerm_subnet" "region1-vnet2-snet1" {
  name                 = var.region1-vnet2-snet1-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
  address_prefixes     = [var.region1-vnet2-snet1-range]
}
resource "azurerm_subnet" "region1-vnet2-snet2" {
  name                 = var.region1-vnet2-snet2-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
  address_prefixes     = [var.region1-vnet2-snet2-range]
}
resource "azurerm_subnet" "region1-vnet2-snet3" {
  name                 = var.region1-vnet2-snet3-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
  address_prefixes     = [var.region1-vnet2-snet3-range]
          delegation {
            name = "delegation"
            service_delegation {
                name    = "Microsoft.Netapp/volumes"
                actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
        }    
    }
}
#Region 2
resource "azurerm_subnet" "region2-vnet1-snet1" {
  name                 = var.region2-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub1.name
  address_prefixes     = [var.region2-vnet1-snet1-range]
}
resource "azurerm_subnet" "region2-vnet1-snet2" {
  name                 = var.region2-vnet1-snet2-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub1.name
  address_prefixes     = [var.region2-vnet1-snet2-range]
}
resource "azurerm_subnet" "region2-vnet1-snet3" {
  name                 = var.region2-vnet1-snet3-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub1.name
  address_prefixes     = [var.region2-vnet1-snet3-range]
}
resource "azurerm_subnet" "region2-vnet2-snet1" {
  name                 = var.region2-vnet2-snet1-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke1.name
  address_prefixes     = [var.region2-vnet2-snet1-range]
}
resource "azurerm_subnet" "region2-vnet2-snet2" {
  name                 = var.region2-vnet2-snet2-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke1.name
  address_prefixes     = [var.region2-vnet2-snet2-range]
}
resource "azurerm_subnet" "region2-vnet2-snet3" {
  name                 = var.region2-vnet2-snet3-name
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke1.name
  address_prefixes     = [var.region2-vnet2-snet3-range]
          delegation {
            name = "delegation"
            service_delegation {
                name    = "Microsoft.Netapp/volumes"
                actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
        }    
    }
}
#RDP Access Rules for Lab
#Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
#Lab NSGs
#Region 1
resource "azurerm_network_security_group" "region1-nsg" {
  name                = "region1-nsg"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg2.name

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
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-security"
   }
}
#Region 2
resource "azurerm_network_security_group" "region2-nsg" {
  name                = "region2-nsg"
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg2.name

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
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-security"
   }
}
# Setup NSG association to all Lab Subnets in each region (excluding ANF subnet)
# Region 1
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet1" {
  subnet_id                 = azurerm_subnet.region1-vnet1-snet1.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet2" {
  subnet_id                 = azurerm_subnet.region1-vnet1-snet2.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet3" {
  subnet_id                 = azurerm_subnet.region1-vnet1-snet3.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet2-snet1" {
  subnet_id                 = azurerm_subnet.region1-vnet2-snet1.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet2-snet2" {
  subnet_id                 = azurerm_subnet.region1-vnet2-snet2.id
  network_security_group_id = azurerm_network_security_group.region1-nsg.id
}
# Region 2
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet1" {
  subnet_id                 = azurerm_subnet.region2-vnet1-snet1.id
  network_security_group_id = azurerm_network_security_group.region2-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet2" {
  subnet_id                 = azurerm_subnet.region2-vnet1-snet2.id
  network_security_group_id = azurerm_network_security_group.region2-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet3" {
  subnet_id                 = azurerm_subnet.region2-vnet1-snet3.id
  network_security_group_id = azurerm_network_security_group.region2-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet2-snet1" {
  subnet_id                 = azurerm_subnet.region2-vnet2-snet1.id
  network_security_group_id = azurerm_network_security_group.region2-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet2-snet2" {
  subnet_id                 = azurerm_subnet.region2-vnet2-snet2.id
  network_security_group_id = azurerm_network_security_group.region2-nsg.id
}
#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix = "keyvault"
}
#Keyvault Creation
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on = [ azurerm_resource_group.rg2 ]
  name                        = random_id.kvname.hex
  location                    = var.loc1
  resource_group_name         = var.azure-rg-2
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-security"
   }
}
#Create KeyVault VM password
resource "random_password" "vmpassword" {
  length = 20
  special = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on = [ azurerm_key_vault.kv1 ]
}
#Public IPs
#Region1
resource "azurerm_public_ip" "region1-dc01-pip" {
  name                = "region1-dc01-pip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  allocation_method   = "Static"
  sku = "Standard"

   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-activedirectory"
   }
}
#Region2
resource "azurerm_public_ip" "region2-dc01-pip" {
  name                = "region2-dc01-pip"
  resource_group_name = azurerm_resource_group.rg3.name
  location            = var.loc2
  allocation_method   = "Static"
  sku = "Standard"

   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-activedirectory"
   }
}
#Create NICs and associate the Public IPs
#Region1
resource "azurerm_network_interface" "region1-dc01-nic" {
  name                = "region1-dc01-nic"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name


  ip_configuration {
    name                          = "region1-dc01-ipconfig"
    subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
	  public_ip_address_id = azurerm_public_ip.region1-dc01-pip.id
  }
  
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-activedirectory"
   }
}
#Region2
resource "azurerm_network_interface" "region2-dc01-nic" {
  name                = "region2-dc01-nic"
  location            = var.loc2
  resource_group_name = azurerm_resource_group.rg3.name


  ip_configuration {
    name                          = "region2-dc01-ipconfig"
    subnet_id                     = azurerm_subnet.region2-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
	  public_ip_address_id = azurerm_public_ip.region2-dc01-pip.id
  }
  
   tags     = {
       Environment  = var.environment_tag
       Function = "baselabv2-activedirectory"
   }
}