# Single Region Base Lab Environment for Azure - Version 2

For an overview of this environment, please see [here](https://jakewalsh.co.uk/introducing-single-region-azure-baselab-v2/).

This environment is also available as a Terraform Module - see [here](https://github.com/jakewalsh90/Terraform-Modules-Azure/tree/main/azure-single-region-baselabv2).

## Manual Steps to complete Lab Environment
#### The two powershell scripts should be run to complete the setup process on the created Virtual Machine. The scripts promote the VM to a domain controller and then setup a basic Lab OU structure. 

These will be in C:\baselabSetup of the DC VM after deployment, and should be run in this order:

1. baselab_DomainSetup.ps1 - the machine will reboot after this.
2. baselab_LabStructure.ps1 - this will setup a basic OU structure.

The lab is now deployed and ready to use. 
