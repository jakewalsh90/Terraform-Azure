# Prerequisites for Terraform Cloud Deployment
This page explains the required pre-requisites for deploying Terraform using Terraform Cloud.

## Creating a Service Principal

In order to interact with Azure, Terraform will require a Service Principal. I've chosen to create this scoped to the Subscription I deploy my Lab into. You may need to scope this differently depending on the environment that you are working with. Doing this is simple using the Azure CLI:

https://github.com/jakewalsh90/Terraform-Azure/blob/1f678d1ced4510fda3f3d04387a1e4011e47b844/Terraform-Cloud-Deployment/scripts/ServicePrincipalSetup#L1

This will provide an output that includes 4 important details - save these as you will need these later on to setup Terraform Cloud:

 - ARM_CLIENT_ID
 - ARM_CLIENT_SECRET
 - ARM_TENANT_ID
 - ARM_SUBSCRIPTION_ID

## Setting up a GitHub Repo

A repository to store Terraform Code is required before you can deploy using Terraform Cloud - this is where our configuration will be stored. Within the following repository there is a demo environment available for download, along with instructions for setup. 

See here: https://github.com/jakewalsh90/Terraform-Azure/tree/main/Core-Environment-DemoLab-v1