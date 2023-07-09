param (
    [Parameter(Mandatory=$true)]
    [string]$dailyshutdowntime
)

Disable-AzContextAutosave -Scope Process
$AzureContext = (Connect-AzAccount -Identity ).context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

$VMs = Get-AzVM | Where-Object {$_.Tags.DailyShutdown -eq "$dailyshutdowntime"}
$VMs | Stop-AzVM -Force
Write-Output "Stopped VMs are $($VMs.Name)"