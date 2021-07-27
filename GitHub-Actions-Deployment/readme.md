# Deploying Terraform using GitHub Actions
To deploy any of the Terraform-Azure Environments within this repository using GitHub Actions, follow the steps outlined below. 

## 1. Fork this repository

Fork this repository - this will then allow you to access backend settings privately and create your own deployments based on the code within. You can then of course customise code, make changes, or upload your own Terraform files.  

## 2. Setup the Backend Storage and Service Principal

Before we can start to run any Actions, we need two supporting items in place:

1. Backend Storage for Terraform to store the state file
2. A Service Principal for Terraform to use to authenticate to our Azure Tenant/Subscriptions

I have created an Azure CLI script that does all this for you! See here: https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/scripts/AzCLIPreReqSetup

Before running the above script, be sure to run through and update the following items in the script to suit your needs. Look through the "Set the below" section of the script and update the variables. Note: Storage Account names must be unique so change this to something that suits your deployment! You will also need to provide a Subscription ID.

When the script runs, you will have a Storage Account and Container setup, and also you will see an output similar to the below:

![Output of Setup Script sample](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/ScriptOutputSample.png)

Copy all of the values outputted by the script and save them somewhere. We will need them for subsequent tasks. 

## 3. Configure a Terraform Backend

Within your Terraform, you will need to configure a backend. This is so that Terraform knows where you would like the State file to be stored. This will be the Azure Resources we created earlier using the Azure CLI Script (Storage Account and Container). The script outputted the values required below - be sure to use your Resource Group, Storage Account, and Container name correctly, based on the output of the Azure CLI script:

    #backend
    terraform {
      backend "azurerm" {
        resource_group_name  = "your-resource-group"
        storage_account_name = "yourstorageaccount123"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
      }
    }
    
Once this has been configured, save the file. For any of the projects in this repo, add the above to azuredeploy.tf in the project folder. 

## 4. Configure the Secrets within the GitHub Repo

At the end of running the CLI Script, you will also have noticed 4 outputs:

    ARM_CLIENT_ID: 
    ARM_CLIENT_SECRET: 
    ARM_TENANT_ID: 
    ARM_SUBSCRIPTION_ID:
    
These are the details we will need to store as Secrets (https://docs.github.com/en/actions/reference/encrypted-secrets) within the Repository, so that Terraform can authenticate correctly to Azure. Configure the secrets using the Settings section of the GitHub repo - name the secrets as shown in the screenshot, and paste in the outputs for each one as the earlier Azure CLI script provided:

![Setting up Secrets](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/GitHubSecrets.png)

We are now ready to start setting up some GitHub Actions! 😄

## 5. Setting up GitHub Actions

The actions for this task are configured using YAML. To keep things simple and easy, two sample Actions have been created within this repository:

1. Terraform Apply - this will setup, initialise, validate, plan and apply Terraform, based on the chosen directory. 
2. Terraform Destroy - this will setup, initialise, and run Terraform destroy, based on the chosen directory.

These are both contained, and configured from within the ./github/workflows folder within this repository. Both of these are set to run only when manually triggered (using [workflow_dispatch]). If you browse to the Actions tab in the repo - you will see both actions are available:

![Actions](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/Actions1.png)

All that needs to be configured before running the actions is the folder within the Action - as this will determine which Terraform files are used. For example, if you wish to deploy the Single Region Azure BaseLab within this repo, change the folder in the image below to ./Single-Region-Azure-BaseLab 

![Actions](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/Actions2.png)

We are now ready to run GitHub Actions! ✅

## 6. Running GitHub Actions and deploying Terraform

As previously mentioned, the actions are set to be run manually within the YAML. So we need to manually trigger the deployment. To do this, browse to the Action, and then follow the steps in the image below:

![Actions](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/Actions3.png)

The actions will then be run, and your Azure Resources will be deployed:

![Actions](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/Actions4.png)

Once completed - you will see the Azure Resources deployed from the Terraform you have run:

![Actions](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/GitHub-Actions-Deployment/images/Actions5.png)

### Hope this helps! :thumbsup: Any issues/questions please reach out via [Twitter](https://twitter.com/jakewalsh90) or open an issue :satellite:

