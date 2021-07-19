# Azure Firewall Single Region Base Lab

## For a lab overview, please visit my blog: [here](https://jakewalsh.co.uk/deploying-and-configuring-azure-firewall-using-terraform/). 

## Overview
This code creates a simple Lab environment within a Single Azure Region. The idea here is that it allows for quick deployment of VNETs, Subnets, and a Domain Controller to simulate smaller environments or provide a quick lab for any test requirements. ### This lab also includes a single Azure Firewall and Firewall Policy to allow quick testing of Firewall requirements/concepts. 

*It is not intended for production use!*

## Actions
The following resources are deployed:

1. Two Resource Groups, one for the Lab infrastructure, and another for Security related items.
2. Two VNETs, a Hub and a Spoke, which are peered. DNS is set on the VNETs to the Domain Controller IP, Azure DNS, and finally, Google DNS. 
3. Three Subnets in each VNET, with a Subnet delegated to Azure NetApp Files in the Spoke VNET. 
4. Uses the [Automatic-ClientIP-NSG](../Automatic-ClientIP-NSG) to setup a Network Security Group that allows RDP access in - this NSG rule uses the external IP of the machine that runs Terraform. 
5. Associates the created NSG to all Lab Subnets.
6. Creates a Key Vault with a randomised name, using [Azure-KeyVault-with-Secret](../Azure-KeyVault-with-Secret), and then creates a password as a Secret within the Key Vault that is used later to setup a VM.
7. Creates a Public IP for the Domain Controller VM.
8. Creates a Network Interface Card and associates the above Public IP. 
9. Creates a Data Disk for NTDS Storage on the Domain Controller VM.
10. Creates a Windows 2019 VM to act as a Domain Controller. The Username for this VM is a Variable, and the Password is saved as a Secret in the Key Vault. (It was automatically generated in Step 6).
11. Attaches the Data Disk created in step 9, with caching Turned off. 
12. Runs a Setup script on the Domain Controller VM (baselab_DCSetup.ps1 within this repos PowerShell folder), as a Custom Script Extension - that carries out the following actions:

  - Uses Chocolatey to install Google Chrome, Putty, Notepad++, WinSCP, Sysinternals, and bginfo.
  - Creates a directory - c:\BaselabSetup.
  - Downloads two further PowerShell scripts (found within this repos PowerShell folder) which will be used to setup the Domain Controller, and create a Lab OU Structure after deployment. 
  - Sets a Windows Firewall Rule to allow File/Printer sharing.
  - Installs the Windows Features required for Active Directory and DNS. 

13. Azure Firewall, including Policy, the Firewall instance, and a Public IP. 

## Manual Steps to complete Lab Environment
#### The two powershell scripts should be run to complete the setup process on the created Virtual Machine. The scripts promote the VM to a domain controller and then setup a basic Lab OU structure. 

These will be in C:\baselabSetup of the DC VM after deployment, and should be run in this order:

1. baselab_DomainSetup.ps1 - the machine will reboot after this.
2. baselab_LabStructure.ps1 - this will setup a basic OU structure.

The lab is now deployed and ready to use. 
