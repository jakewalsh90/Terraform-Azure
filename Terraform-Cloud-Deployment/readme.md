# Setting up for Terraform Cloud Deployment
This page explains the required pre-requisites for deploying Terraform using Terraform Cloud.

## Creating a Service Principal

In order to interact with Azure, Terraform will require a Service Principal. I've chosen to create this scoped to the Subscription I deploy my Lab into. You may need to scope this differently depending on the environment that you are working with:

Doing this is simple using the Azure CLI:

https://github.com/jakewalsh90/Terraform-Azure/blob/1f678d1ced4510fda3f3d04387a1e4011e47b844/Terraform-Cloud-Deployment/scripts/ServicePrincipalSetup#L1

