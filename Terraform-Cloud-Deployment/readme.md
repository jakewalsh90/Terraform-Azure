# Prerequisites for Terraform Cloud Deployment
This page explains the required pre-requisites for deploying Terraform using Terraform Cloud.

## Creating a Service Principal

In order to interact with Azure, Terraform will require a Service Principal. I've chosen to create this scoped to the Subscription I deploy my Lab into. You may need to scope this differently depending on the environment that you are working with:

Doing this is simple using the Azure CLI:

https://github.com/jakewalsh90/Terraform-Azure/blob/1f678d1ced4510fda3f3d04387a1e4011e47b844/Terraform-Cloud-Deployment/scripts/ServicePrincipalSetup#L1

This will provide an output that includes 4 important details - save these as you will need these later on to setup Terraform Cloud:

 - ARM_CLIENT_ID
 - ARM_CLIENT_SECRET
 - ARM_TENANT_ID
 - ARM_SUBSCRIPTION_ID

## Setting up a GitHub Repo

 A repository to store Terraform Code is required before you can deploy using Terraform Cloud - this is where our configuration will be stored. Within this repository there is a demo environment for Terraform Cloud called "Terraform-Cloud-Demo-Lab" that provides a basic environment for testing. 

You can download this here: https://github.com/jakewalsh90/Terraform-Azure/tree/main/Terraform-Cloud-Demo-Lab

You will notice that various variables are set but populated with dummy data - this will be replaced later on within Terraform Cloud:

### Provider.tf

https://github.com/jakewalsh90/Terraform-Azure/blob/006e9950c27eb62dc1c64af0e43e4e54d42642f8/Terraform-Cloud-Demo-Lab/provider.tf#L14-L25

### Variables.tf

https://github.com/jakewalsh90/Terraform-Azure/blob/caf612f5d8a7b88bb3865d5b496f61e0698e13ae/Terraform-Cloud-Demo-Lab/variables.tf#L1-L20

## Next Steps

Once you have a Repository and Service Principal Setup - you can then move into Terraform Cloud and start your deployment!