# Automating NSG rules with an external IP in Terraform

## Overview
This code dynamically creates an Azure Network Security Group (NSG) using Terraform. The NSG allows inbound RDP access from the Client IP of the machine running Terraform only. The IP address is gathered from an IP check service automatically. 

### A full overview is available here: https://jakewalsh.co.uk/automating-nsg-rules-with-an-external-ip-in-terraform/

## Actions
This code creates a data source within Terraform, and then uses this during deployment, so that the NSG rule is created dynamically based on the Client IP. To do this, a data source is used, and a URL from an IP check service - see [azuredeploy.tf](azuredeploy.tf). 

In this example 3 things are carried out:

 1. Creates a Resource Group to hold Resources
 2. Checks the Client IP with https://ipv4.icanhazip.com/
 3. Creates an NSG that allows inbound RDP using the IP address from the IP Check Service above. 
 
 The NSG can then be applied to whatever resources you wish - and only your Client IP will be able to access them over RDP.
