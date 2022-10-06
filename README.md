# Terraform-Azure

[![Check Links](https://github.com/jakewalsh90/Terraform-Azure/actions/workflows/links.yml/badge.svg)](https://github.com/jakewalsh90/Terraform-Azure/actions/workflows/links.yml)

This repository contains Terraform sample code for Azure -  mostly smaller deployments, labs, test environments. These are environments I used to demonstrate/test. Feel free to use these as you wish! :smile:

Due to the fact that some of the Terraform Projects in this Repository are unlikely to be used alone, the samples provided may also contain supporting elements. So in some cases, items like Resource Groups, VNETs, Subnets and more are deployed to support whatever is being demonstrated. 
  
To utilise the code you may therefore just deploy as is and see the concept being demonstrated,  *without needing to adapt the code or rework it.* You can then take any elements you require and work them into your code, to move forward from there. 

## How to Deploy

### :heavy_check_mark: Install the Right Tools First!

I have setup a Chocolatey script that will provide all the tools you need to work with Terraform on Azure - see [here](https://github.com/jakewalsh90/Terraform-Azure/blob/main/Chocolatey-Setup/TerraformApps.ps1) or use the Chocolatey install script below:

    #Chocolatey setup and installation script for using Terraform
    #Set Execution Policy to allow script to run
    Set-ExecutionPolicy Bypass -Scope Process -Force 
    #Chocolatey install
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    #Chocolatey apps
    choco install vscode -y -no-desktopshortcuts
    choco install terraform -y -no-desktopshortcuts
    choco install azure-cli -y -no-desktopshortcuts

### :arrow_right: GitHub Actions

These projects can be deployed easily using GitHub Actions - for a full guide, please see [here](https://github.com/jakewalsh90/Terraform-Azure/tree/main/GitHub-Actions-Deployment).

### :arrow_right: Manual Deployment
 
For most of the Projects the following files are provided:

- azuredeploy.tf
- variables.tf
- terraform.tfvars
- provider.tf

These should be placed into a directory, and then Terraform initialised and applied. (Note: some larger projects split out the Terraform elements into separate files for sanity reasons.) Note that for some projects the TF Files are split out into seperate files for ease of use!

## :question: Want to see new Projects in this Repository?

Please reach out to me via my Website or Twitter - I am happy to create new projects or collaborate!

## :question: Found an issue or Bug? 

Please open an issue, or feel free to create a pull request. You can also reach out to me via my Website or Twitter! :)

## :heavy_check_mark: Projects in this Repository

### 1. **Automatic NSG based on the Client IP of the Machine running Terraform**
*This creates a data item that gets the external IP of the machine that is running Terraform. The IP is then used to create an    inbound security rule inside a Network Security Group.* **See: [Automatic-ClientIP-NSG](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Automatic-ClientIP-NSG)**

### 2. **Azure KeyVault with Secret for Virtual Machine Password**
*This creates an Azure Key Vault using a random name like "keyvault##########", and then creates a password string, using the random_string resource, which is stored inside the KeyVault. This can then be used during the setup of VMs with Terraform .* **See: [Azure-KeyVault-with-Secret](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Azure-KeyVault-with-Secret)**

### 3. **Single Region Base Lab Environment for Azure**
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

### 9. **Azure vWAN Demo Lab**
*This code sets up an Azure vWAN Demo Lab. Based on a two Region deployment, with documentation.* **See: [Azure-vWAN-DemoLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/vWAN-DemoLab)** Details of this Lab are also available on my blog [here](https://jakewalsh.co.uk/deploying-azure-virtual-wan-using-terraform/).

### 10. **Web Server IIS Demo Lab**
*This code sets up an Azure Base Lab, based on the Single Region Lab above, but installs IIS onto the VM it creates using a Custom Script Extension* **See: [Web-Server-IIS-DemoLab](https://github.com/jakewalsh90/Terraform-Azure/tree/main/Web-Server-IIS-DemoLab)**

### 10. **cidrsubnet Function Demo**
*This code demonstrates the use of the cidrsubnet function, and shows how it can be used to create an environment whereby network CIDR ranges can be specified once, and then Terraform used to do the splitting of networks easily.* **See: [CIDRSubnet-Demo](https://github.com/jakewalsh90/Terraform-Azure/tree/main/CIDRSubnet-Demo)**
