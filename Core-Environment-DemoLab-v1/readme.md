This lab is an environment that I deploy with Terraform Cloud to quickly get an Azure Environment up and running - allowing me to demonstrate concepts and test ideas. 

These labs can also be used with other deployment methods and tooling, but the guide below is for Terraform Cloud. Follow the notes below to deploy. 

For a guide on setting up a Service Principal see here: https://github.com/jakewalsh90/Terraform-Azure/tree/main/Terraform-Cloud-Deployment

## Pre reqs:

The following elements need to be added to Terraform Cloud as variables:

### All Labs
 - admin_id - The admin user id to be added to the Key Vault access policies. 
 - client_id - Service Principal ID
 - client_secret - Service Principal Secret
 - subscription_id - Subscription ID you want to deploy into
 - tenant_id - Tenant ID of the Azure Tenant you want to deploy into
 - vpn_app_id - ID of the VPN Enterprise Application, see https://learn.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant