# Dual Region Base Lab Environment for Azure

## Overview
This code creates a simple Lab environment within two Azure Regions. The idea here is that it allows for quick deployment of VNETs, Subnets, and Domain Controllers to simulate smaller environments or provide a quick lab for any test requirements.

*It is not intended for production use!*

## Actions
The following resources are deployed:

1. Three Resource Groups, one for the Lab infrastructure in each Region, and another for Security related items.
2. Four VNETs, a Hub and a Spoke in each region, which are peered. There is also a Global peering between the two Hub VNETS. DNS is set on the VNETs to the Domain Controller IP, Azure DNS, and finally, Google DNS. 
3. Three Subnets in each VNET, with a Subnet delegated to Azure NetApp Files in the Spoke VNET. 
4. Uses the [Automatic-ClientIP-NSG](../Automatic-ClientIP-NSG) to setup a Network Security Group that allows RDP access in - this NSG rule uses the external IP of the machine that runs Terraform. 
5. Associates the created NSG to all Lab Subnets.
6. Creates a Key Vault with a randomised name, using [Azure-KeyVault-with-Secret](../Azure-KeyVault-with-Secret), and then creates a password as a Secret within the Key Vault that is used later to setup a VM.
7. Creates Public IPs for the Domain Controller VMs.
8. Creates a Network Interface Card and associates the above Public IP.

Yet to be added:

9. Creates a Data Disk for NTDS Storage on the Domain Controller VM.
10. Creates a Windows 2019 VM to act as a Domain Controller. The Username for this VM is a Variable, and the Password is saved as a Secret in the Key Vault. (It was automatically generated in Step 6).
11. Attaches the Data Disk created in step 9, with caching Turned off. 
12. Runs a Setup script on the Domain Controller VM (baselab_DCSetup.ps1 within this repos PowerShell folder), as a Custom Script Extension - that carries out the following actions:

  - Uses Chocolatey to install Google Chrome, Putty, Notepad++, WinSCP, Sysinternals, and bginfo.
  - Creates a directory - c:\BaselabSetup.
  - Downloads two further PowerShell scripts (found within this repos PowerShell folder) which will be used to setup the Domain Controller, and create a Lab OU Structure after deployment. 
  - Sets a Windows Firewall Rule to allow File/Printer sharing.
  - Installs the Windows Features required for Active Directory and DNS. 

## Manual Steps to complete Lab Environment

[ TBC ]