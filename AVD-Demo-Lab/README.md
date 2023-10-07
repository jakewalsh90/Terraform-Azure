# AVD Demo Environment

This environment uses Terraform and Packer to provide the foundations for an AVD Environment that can be added to most DevOps toolsets (GitHub Actions, Azure DevOps etc).Current files within this repo are:

 - Terraform-Single-Region-Azure-BaseLab-V2 - This Terraform code creates a basic Azure environment that will provide the foundations required to Demostrate AVD (and other Azure services if required).
 - Packer - This code provides Packer files that can be used to create machine images for AVD. Customisation within these images is currently done using PowerShell, with applications installed using Chocolatey. Note: Packer files are now located in their own repository here: https://github.com/jakewalsh90/Packer-Azure
