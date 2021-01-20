# Creating an Azure Key Vault with a Secret

## Overview
This code creates a randomly named Azure Key Vault (keyvault##########), and then creates a Secret based on a random string, and stores that within the Key Vault. This allows automated creation of unique Key Vaults (as Key Vault names need to be unique) and unique passwords - ideal for environments that need to be created by multiple people - labs for example.

### A full overview is available here: https://jakewalsh.co.uk/automating-azure-key-vault-and-secrets-using-terraform/

## Actions
This code creates a Key Vault name using the random_id resource, with the prefix of "keyvault". This is then used to create a Key Vault. The random_password resource is then used to create a unique password. This is saved within the Key Vault and can then be used to setup VMs as required. See [azuredeploy.tf](azuredeploy.tf)

In this example the following actions are carried out:

1. Creates a Resource Group to hold Resources.
2. Creates a Key Vault name using the random_id resource, prefixed with "keyvault". 
3. Creates a Key Vault using the generated name, and sets permissions for Secrets within. 
4. Creates a Password using the random_password resource. 
5. Stores the generated Password inside the generated Key Vault.

The Secret can then be used as the administrator password for VMs created in Terraform. The password value can be accessed via the Key Vault. When creating a VM using this code, reference the password as below:

  admin_password      = azurerm_key_vault_secret.vmpassword.value
