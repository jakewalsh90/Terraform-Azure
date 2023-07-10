# Azure Automation Demo Environment

This lab creates a simple Azure Automation environment, that shuts down VMs with a specific tag on a scheduled basis. The tag required on any VMs you wish to use with this Lab is "DailyShutdown" and the Tag Value for this Lab is "1800". VMs with this Tag and Value will be shut down every day at 1800. Note the time zone is set to Europe/London - you will also need to adjust the start date as required. 

The following resources are created:

 - A Resource Group.
 - Azure Automation Account.
 - Azure Automation Runbook.
 - PowerShell script to shutdown VMs with a specific tag.
 - Azure Automation Schedule.
 - Azure Automation Managed Identity (for Azure Automation Runbook, which assigns Contributor permissions to the current Subscription).
 - Azure Automation Schedule, and Job Schedule set to run every day at 6pm. 