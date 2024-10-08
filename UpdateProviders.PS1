# This script allows us to update the provider versions in all Provider files within this Repo. 
# Provider Details:
$oldazurerm = '
      source  = "hashicorp/azurerm"
      version = ">= 4.4.0"
'
$newazurerm = '
      source  = "hashicorp/azurerm"
      version = ">= 4.4.0"
'
$oldrandom = '
      source  = "hashicorp/random"
      version = ">= 3.5.0"
'
$newrandom = '
      source  = "hashicorp/random"
      version = ">= 3.6.3"
'
Get-ChildItem . -Recurse | Where-Object Name -eq "provider.tf" | foreach-object {
  (Get-Content -Raw $_).Replace($oldazurerm, $newazurerm)| Set-Content $_
  (Get-Content -Raw $_).Replace($oldrandom, $newrandom)| Set-Content $_
}