param (
    [Parameter(Mandatory=$true)]
    [string]$DailyShutdownTime
)

Disable-AzContextAutosave -Scope Process
$AzureContext = (Connect-AzAccount -Identity ).context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

$VMs = Get-AzVM | Where-Object {$_.Tags.DailyShutdown -eq "$DailyShutdownTime"}
$VMs | Stop-AzVM -Force
Write-Output "Stopped VMs are $($VMs.Name)"