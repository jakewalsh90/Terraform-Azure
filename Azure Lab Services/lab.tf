# Resource Group for Lab
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.labname}-${var.region}"
  location = var.region
  tags = {
    Environment = var.labname
    Function    = "AzureLabServices"
  }
}
# Lab Service Plan
resource "azurerm_lab_service_plan" "plan1" {
  name                = "lsp-${var.labname}-${var.region}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  allowed_regions     = [var.region]

  support {
    email        = "jake@jakewalsh.co.uk"
    instructions = "Welcome to your Azure Lab, please raise a support request if you encounter any issues"
    url          = "https://jakewalsh.co.uk"
  }
  tags = {
    Environment = var.labname
    Function    = "AzureLabServices"
  }
}
# Lab
resource "azurerm_lab_service_lab" "lab1" {
  name                = "lab-${var.labname}-${var.region}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  title               = "Lab 1"
  description         = "Virtual Machine for Lab Environment"
  lab_plan_id         = azurerm_lab_service_plan.plan1.id

  connection_setting {
    client_rdp_access = "Public"
  }

  security {
    open_access_enabled = false
  }

  virtual_machine {
    shared_password_enabled = true

    admin_user {
      username = var.labusername
      password = azurerm_key_vault_secret.vmpassword.value
    }

    image_reference {
      offer     = "windows-11"
      publisher = "MicrosoftWindowsDesktop"
      sku       = "win11-21h2-pro"
      version   = "latest"
    }

    sku {
      name     = "Classic_Fsv2_8_16GB_128_S_SSD"
      capacity = 1
    }
  }
  tags = {
    Environment = var.labname
    Function    = "AzureLabServices"
  }
}