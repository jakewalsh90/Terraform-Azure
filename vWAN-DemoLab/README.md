# Azure vWAN DemoLab

## :heavy_check_mark: Overview
This is work in progress to provide a Terraform based demonstration of Azure vWAN 10/06/2022

## :question: What this Lab Deploys

This lab deploys the following:
1. A Resource Group in two Azure Regions (based on variables)
2. A vWAN in the Primary Region
3. A vWAN Hub in two Azure Regions
4. A vNet in each Azure Region which is connected to the vWAN Hub.
5. A Subnet and NSG in each of the above vNets. 
6. A Virtual Machine in each Azure Region (in the Regional vNets), to allow testing of Connectivity. Note: these VMs have a Public IP and RDP is enabled for easy testing access. 