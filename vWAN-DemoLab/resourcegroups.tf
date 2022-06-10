# Resource Groups vWAN
resource "azurerm_resource_group" "rg1" {
  name     = "${var.lab-name}-vwan-rg-01"
  location = var.region1
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = "${var.lab-name}-vwan-rg-02"
  location = var.region2
  tags = {
    Environment = var.environment_tag
    Function    = "vWAN-DemoLab-ResourceGroups"
  }
}