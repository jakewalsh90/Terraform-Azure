# Resource Groups vWAN - Region 1
resource "azurerm_resource_group" "region1-rg1" {
  name     = "${var.lab-name}-${var.region1}-vwan-rg-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
# Resource Groups vWAN - Region 2
resource "azurerm_resource_group" "region2-rg1" {
  name     = "${var.lab-name}-${var.region2}-vwan-rg-01"
  location = var.region2
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}