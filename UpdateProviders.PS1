# This script allows us to update the provider versions in all Provider files within this Repo. 
# Provider Details:
$oldazurerm = '
      source  = "hashicorp/azurerm"
      version = ">= 3.77.0"
'
$newazurerm = '
      source  = "hashicorp/azurerm"
      version = ">= 3.79.0"
'
$oldrandom = '
      source  = "hashicorp/random"
      version = ">= 3.5.0"
'
$newrandom = '
      source  = "hashicorp/random"
      version = ">= 3.5.1"
'
Get-ChildItem . -Recurse | Where-Object Name -eq "provider.tf" | foreach-object {
  (Get-Content -Raw $_).Replace($oldazurerm, $newazurerm)| Set-Content $_
  (Get-Content -Raw $_).Replace($oldrandom, $newrandom)| Set-Content $_
}