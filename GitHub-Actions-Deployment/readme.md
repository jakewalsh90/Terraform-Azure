# Readme for Terraform deployment using GitHub Actions
To deploy any of the Terraform-Azure Environments within this repository using GitHub Actions, follow the guide below. 

### Please note this is still work in progress!

## 1. Fork this repository

Fork this repository - this will then allow you to access backend settings privately and create your own deployments based on the code within. You can then of course customise code and make changes as it will be your own copy.  

## 2. Setup the Backend Storage and Service Principal

Before we can start to run any Actions, we need two supporting items in place:

1. Some backend Storage for Terraform to store the state file
2. A Service Principal for Terraform to use to authenticate to our Azure Tenant/Subscriptions

I have created an Azure CLI script that does all this for you! See here: https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/AzCLIPreReqSetup

Before running the above script, be sure to run through and update the following items in the script to suit your needs:

1. Run through the "Set the below" section of the script and update the variables. Note: storage account names must be unique so change this to something that suits your deployment! You will also need to provide a Subscription ID.

When the script runs, you will have a Storage Account and Container setup, and also you will see an output similar to the below:

![Output of Setup Script sample](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/ScriptOutputSample.png)

Copy all of the values outputted by the script and save them somewhere. We will need them for subsequent tasks. 

## 3. Configure your backend within Terraform

Within your Terraform, you will need to configure a backend. This is so that Terraform knows where you would like the State file to be stored. This will be our Azure Resources we created earlier (Storage Account and Container), using the script. The script outputted the values required below - be sure to use your Resource Group, Storage Account, and Container name correctly (based on the output of the script, as shown above):

    #backend
    terraform {
      backend "azurerm" {
        resource_group_name  = "your-resource-group"
        storage_account_name = "yourstorageaccount123"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
      }
    }
    
Once this has been configured, save the file. 

## 4. Configure the Secrets within the GitHub Repo


