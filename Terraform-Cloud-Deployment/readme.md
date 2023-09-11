# Setting up for Terraform Cloud Deployment
This page explains the required pre-requisites for deploying Terraform using Terraform Cloud.

## Creating a Service Principal

In order to interact with Azure, Terraform will require a Service Principal. I've chosen to create this scoped to the Subscription I deploy my Lab into. You may need to scope this differently depending on the environment that you are working with:

Doing this is simple using the Azure CLI:

