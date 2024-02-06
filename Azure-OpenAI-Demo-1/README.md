# Azure Open AI Demo

** Note: this is work in progress! **

## Overview
This code creates an Azure Cognitive Services Resource - with Azure Open AI Services, to allow rapid deployment and testing. 

This environment deploys the following items:

 1. A Resource Group in a Region that is based upon a variable. 
 2. Two Random IDs (using the Random Provider) to be used for naming. 
 3. An Azure OpenAI Resource
 4. Two Models - gpt-35-turbo and text-embedding-ada-002 within the Azure OpenAI Resource. 
 5. Private Networking Features - including VNET, Subnet, Custom Subdomain Name (For the OpenAI Resource), and a Service Endpoint. 

Note: Private Networking is selected by changing the variable "privatenetworking" to true within the terraform.tfvars file. 

CIDR Ranges are also adjusted for the VNET and Subnet within the terraform.tfvars. 