# Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = "rg-${var.region}-aoai"
  location = var.region
}
# Random IDs for OAI Resources
resource "random_id" "cognitive" {
  byte_length = 6
}
resource "random_id" "pn-cognitive" {
  byte_length = 6
}
# Cognitive Services - without Private Networking
resource "azurerm_cognitive_account" "cognitive1" {
  count               = var.privatenetworking ? 0 : 1
  name                = "oai-${random_id.cognitive.hex}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku_name            = "S0"
  kind                = "OpenAI"
}
# Cognitive Deployments - without Private Networking
resource "azurerm_cognitive_deployment" "gpt-35-turbo" {
  count                = var.privatenetworking ? 0 : 1
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.cognitive1[0].id
  model {
    format = "OpenAI"
    name   = "gpt-35-turbo"
  }
  scale {
    type = "Standard"
  }
}
resource "azurerm_cognitive_deployment" "text-embedding-ada-002" {
  count                = var.privatenetworking ? 0 : 1
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.cognitive1[0].id
  model {
    format = "OpenAI"
    name   = "text-embedding-ada-002"
  }
  scale {
    type = "Standard"
  }
}
# Cognitive Services - with Private Networking
resource "azurerm_cognitive_account" "pn-cognitive1" {
  count                 = var.privatenetworking ? 1 : 0
  name                  = "oai-${random_id.pn-cognitive.hex}"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  sku_name              = "S0"
  kind                  = "OpenAI"
  custom_subdomain_name = "oai-${random_id.pn-cognitive.hex}"

  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = azurerm_subnet.subnet1-aoai[0].id
    }
  }

}
# Cognitive Deployments - with Private Networking
resource "azurerm_cognitive_deployment" "pn-gpt-35-turbo" {
  count                = var.privatenetworking ? 1 : 0
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.pn-cognitive1[0].id
  model {
    format = "OpenAI"
    name   = "gpt-35-turbo"
  }
  scale {
    type = "Standard"
  }
}
resource "azurerm_cognitive_deployment" "pn-text-embedding-ada-002" {
  count                = var.privatenetworking ? 1 : 0
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.pn-cognitive1[0].id
  model {
    format = "OpenAI"
    name   = "text-embedding-ada-002"
  }
  scale {
    type = "Standard"
  }
}
# VNET and Subnet for Private Networking - if required
resource "azurerm_virtual_network" "vnet1" {
  count               = var.privatenetworking ? 1 : 0
  name                = "vnet-${var.region}-aoai"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.region1-cidr]
}
resource "azurerm_subnet" "subnet1-aoai" {
  count                = var.privatenetworking ? 1 : 0
  name                 = "subnet1-aoai"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1[0].name
  address_prefixes     = [var.region1-subnet]
  service_endpoints    = ["Microsoft.CognitiveServices"]
}