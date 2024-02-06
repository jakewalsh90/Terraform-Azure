# Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = "rg-${var.region}-aoai"
  location = var.region
}
# Random ID for OAI Resources
resource "random_id" "cognitive" {
  byte_length = 4
}
# Cognitive Services
resource "azurerm_cognitive_account" "cognitive1" {
  name                = "oai-${random_id.cognitive.hex}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku_name            = "S0"
  kind                = "OpenAI"
}
# Cognitive Deployments
resource "azurerm_cognitive_deployment" "gpt-35-turbo" {
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.cognitive1.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
  }
  scale {
    type = "Standard"
  }
}
resource "azurerm_cognitive_deployment" "text-embedding-ada-002" {
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.cognitive1.id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
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

  subnet = [
    {
      name           = "subnet1-aoai"
      address_prefix = var.region1-subnet
    }
  ]
}
