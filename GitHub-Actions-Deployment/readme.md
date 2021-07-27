# Readme for Terraform deployment using GitHub Actions
To deploy any of the Terraform-Azure Environments within this repo using GitHub Actions, follow the guide below. 

## 1. Fork this repo

Fork this repository - this will then allow you to access backend settings privately and create your own deployments based on the code within. 

## 2. Setup the Backend Storage and Service Principal

Before we can start to run any Actions, we need two supporting items in place:

1. Some backend Storage for Terraform to store the state file
2. A Service Principal for Terraform to use to authenticate to our Azure Tenant/Subscriptions

I have created an Azure CLI script that does all this for you! See here: https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/AzCLIPreReqSetup
