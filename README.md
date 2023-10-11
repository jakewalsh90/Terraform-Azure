# Terraform-Azure

[![Check Links](https://github.com/jakewalsh90/Terraform-Azure/actions/workflows/links.yml/badge.svg)](https://github.com/jakewalsh90/Terraform-Azure/actions/workflows/links.yml)

This repository contains Terraform sample code for Azure -  mostly smaller deployments, labs, test environments. These are environments I used to demonstrate/test. Feel free to use these as you wish! :smile:

Due to the fact that some of the Terraform Projects in this Repository are unlikely to be used alone, the samples provided may also contain supporting elements. So in some cases, items like Resource Groups, VNETs, Subnets and more are deployed to support whatever is being demonstrated. 
  
To utilise the code you may therefore just deploy as is and see the concept being demonstrated, without needing to adapt the code or rework it. You can then take any elements you require and work them into your code, to move forward from there. 

## New to Azure Terraform?

### :heavy_check_mark:  Check out my Getting Started Blog Series:

- Part 1 - [Setup and Tooling](https://jakewalsh.co.uk/a-simple-azure-terraform-walkthrough-part-1/)
- Part 2 - [Running our first deployment](https://jakewalsh.co.uk/a-simple-azure-terraform-walkthrough-part-2/)
- Part 3 - [Tips Tricks and Further Reading](https://jakewalsh.co.uk/a-simple-azure-terraform-walkthrough-part-3/)

## How to Deploy

### :heavy_check_mark: Install the Right Tools First!

I have setup a Chocolatey script that will provide all the tools you need to work with Terraform on Azure - see [here](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Setup-Scripts) or use the Chocolatey install script below:

https://github.com/jakewalsh90/Terraform-Azure/blob/965a026f807446313f8e7d5e2abab6157d632812/Setup-Scripts/TerraformApps.ps1#L1-L8

### :arrow_right: GitHub Actions

These projects can be deployed using GitHub Actions - for a full guide, please see [here](https://github.com/jakewalsh90/Terraform-Azure/tree/main/GitHub-Actions-Deployment).

### :arrow_right: Terraform Cloud

These projects can be deployed using Terraform Cloud - for a prerequisite guide, please see [here](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Terraform-Cloud-Deployment).

### :arrow_right: Manual Deployment
 
For most of the Projects the following files are provided:

- azuredeploy.tf
- variables.tf
- terraform.tfvars
- provider.tf

These should be placed into a directory, and then Terraform initialised and applied. Note that for some projects the TF Files are split out into seperate files for ease of use!

## :question: Want to see new Projects in this Repository?

Please reach out to me via my Website - I am happy to create new projects or collaborate!

## :question: Found an issue or Bug? 

Please open an issue, or feel free to create a pull request. You can also reach out to me via my Website :)

## :heavy_check_mark: Projects in this Repository

### 1. **Automatic NSG based on the Client IP of the Machine running Terraform**
*This creates a data item that gets the external IP of the machine that is running Terraform. The IP is then used to create an    inbound security rule inside a Network Security Group.* **See: [Automatic-ClientIP-NSG](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Automatic-ClientIP-NSG)**

### 2. **Azure KeyVault with Secret for Virtual Machine Password**
*This creates an Azure Key Vault using a random name like "keyvault##########", and then creates a password string, using the random_string resource, which is stored inside the KeyVault. This can then be used during the setup of VMs with Terraform .* **See: [Azure-KeyVault-with-Secret](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Azure-KeyVault-with-Secret)**

### 3. **Single Region Base Lab Environment for Azure**
✅ **Note: Now updated to V2 - see [Single Region Azure Base Lab V2](https://github.com/jakewalsh90/Terraform-Azure#14-single-region-base-lab-environment-for-azure---v2)**.
*This code creates a simple Lab environment within a Single Azure Region. The idea here is that it allows for quick deployment of VNETs, Subnets, and a Domain Controller to simulate smaller environments or provide a quick lab for any test requirements.* **See: [Single-Region-Azure-BaseLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Single-Region-Azure-BaseLab)** 

### 4. **Single Region Base Lab Environment for Azure - with Ansible VM**
*This code creates a simple Lab environment within a Single Azure Region, and also includes an Ubuntu VM with Ansible installed. The idea here is that it allows for quick deployment of VNETs, Subnets, and a Domain Controller to simulate smaller environments or provide a quick lab for any test requirements, and also to provide Ansible.* **See: [Single-Region-Azure-BaseLab-with-Ansible](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Single-Region-Azure-BaseLab-with-Ansible)**

### 5. **Ansible Quickstart Lab**
*This code creates a simple Azure Environment with an Ubuntu Server VM, and uses a Custom Script Extension to install Ansible. You can then use Ansible as you require.* **See [Ansible-Quickstart](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Ansible-Quickstart)**

### 6. **Dual Region Base Lab Environment for Azure**
*This code creates a simple Lab environment within two Azure Regions. The idea here is that it allows for quick deployment of VNETs, Subnets, and two Domain Controllers to simulate smaller environments or provide a quick lab for any test requirements.* **See: [Dual-Region-Azure-BaseLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Dual-Region-Azure-BaseLab)**

### 7. **Azure NetApp Files Cross Region Replication Base Lab**
*This code creates a simple Lab environment within two Azure Regions. A number of Azure NetApp Files Resources are also provisioned ready for setting up a basic Active Directory Domain, and then configuring Azure NetApp Files, with Cross Region Replication. This Lab is covered in detail on my blog, and was the subject of a user group talk, for which the slides are available in my events repo:* **See: [Azure-NetApp-Files-CRR-BaseLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Azure-NetApp-Files-CRR-BaseLab)**

### 8. **Azure Firewall Demolab**
*This code sets up an Azure Base Lab, based on the Single Region Lab above, but also includes Azure Firewall. Firewall options, policies, and deployment settings can be tested using this lab.* **See: [Azure-Firewall-Baselab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Azure-Firewall-DemoLab)**

### 9. **Azure Virtual WAN Demo Lab**
*This code sets up an Azure vWAN Demo Lab. Based on a two Region deployment, with documentation.* **See: [Virtual-WAN-Demo](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Virtual-WAN-Demo)** Details of this Lab are also available on my blog [here](https://jakewalsh.co.uk/deploying-azure-virtual-wan-using-terraform/).

### 10. **Web Server IIS Demo Lab**
*This code sets up an Azure Base Lab, based on the Single Region Lab above, but installs IIS onto the VM it creates using a Custom Script Extension.* **See: [Web-Server-IIS-DemoLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Web-Server-IIS-DemoLab)**

### 11. **cidrsubnet Function Demo**
*This code demonstrates the use of the cidrsubnet function, and shows how it can be used to create an environment whereby network CIDR ranges can be specified once, and then Terraform used to do the splitting of networks easily.* **See: [CIDRSubnet-Demo](https://github.com/jakewalsh90/Terraform-Azure/tree/main/CIDRSubnet-Demo)**

### 12. **cidrhost Function Demo**
*This code demonstrates the use of the cidrhost function, and shows how it can be used to create an environment whereby host IP addresses can be calculated from a network CIDR range. This demo includes showing usage within Virtual Network DNS Servers, Network Interfaces, NSGs, and Route Tables.* **See: [CIDRHost-Demo](https://github.com/jakewalsh90/Terraform-Azure/tree/main/CIDRHost-Demo)**

### 13. **Chaos Studio Test Environment**
*This code sets up a demonstration environment to support a blog post around Azure Chaos Studio. It builds out a deployment of Windows Servers, running IIS, across two Regions. Azure Load Balancer, Firewall, and Traffic Manager are then used to provide Load Balancing and Failover.* **See: [Chaos-Studio-Test](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Chaos-Studio-Test).** *The blog post for this environment is also available* **[here](https://jakewalsh.co.uk/exploring-the-azure-chaos-studio-preview/).**

### 14. **Single Region Base Lab Environment for Azure - V2**
*Updated from my Single Region Azure Base Lab - This V2 version creates a simple Lab environment within a Single Azure Region. The idea here is that it allows for quick deployment of VNETs, Subnets, Domain Controller/Additional VMs to simulate smaller environments or provide a quick lab for any test requirements. Now includes optional features, enabled/disabled via Variables; Azure Bastion, Azure Firewall, AVD Supporting Elements, and a Virtual Network Gateway.* **See: [Single-Region-Azure-BaseLab-v2](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Single-Region-Azure-BaseLab-v2)**

### 15. **Azure Automation Demo**
*This environment creates a simple Azure Automation Demo Environment, along with a PowerShell runbook. A schedule that is used to trigger the runbook is used - which then shuts down VMs based on a Tag.* **See: [Azure-Automation-Demo](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Azure-Automation-Demo)**

### 16. **Cross-Region (Global) Azure Load Balancer Lab Environment**
*This environment creates a demo environment for the Azure Cross-Region (Global) Load Balancer. Using a mixture of Virtual Machines running IIS, and Regional Load Balancers as a foundation, a Cross-Region (Global) Load Balancer is then deployed to Load Balance between Regions. This can be used for basic testing and learning.* **See: [Cross-Region-Load-Balancer-Lab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Cross-Region-Load-Balancer-Lab)**

### 17. **Cost Optimisation Example Lab**
*This environment creates a sample version of my Single Region Azure BaseLab V2, but with many unused resources (Disks, Public IPs, etc.) to allow cost management tooling to pick these up and recommend optimisations as a result. It is not recommended to use this environment for anything other than demonstrating cost management tooling.* **See: [Cost-Optimisation-Example-Lab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Cost-Optimization-Example-Lab)**

### 18. **Core Environment Demo Lab**
*This environment creates a simple Azure environment designed to be ready to deploy with Terraform Cloud, with the necessary provider.tf and variables.tf configuration to deploy using Terraform Cloud. This lab is based around Azure Virtual WAN, Firewall, and many more services - and can be quickly deployed to numerous regions with an integrated Virtual WAN Topology. This lab also includes a Point to Site VPN, and makes use of Map Variables, CIDR Subnet and many more interesting aspects.* **See: [Core-Environment-DemoLab-v1](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Core-Environment-DemoLab-v1)**