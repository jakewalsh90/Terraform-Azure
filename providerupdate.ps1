# Providers: azurerm, random
$oldazurerm = 'azurerm = {
    # Specify what version of the provider we are going to utilise
    source  = "hashicorp/azurerm"
    version = ">= 3.69.0"
  }'
$newazurerm = 'azurerm = {
    # Specify what version of the provider we are going to utilise
    source  = "hashicorp/azurerm"
    version = ">= 3.70.0"
  }'
# $oldrandom = '    random = {
#     source  = "hashicorp/random"
#     version = ">= 3.5.0"
#   }'
# $newrandom = '    random = {
#     source  = "hashicorp/random"
#     version = ">= 3.5.1"
#   }'
get-childitem -Recurse -Path . -Filter provider.tf | foreach-object {
    get-content $_ | foreach-object {$_ -replace $oldazurerm, $newazurerm} | set-content $_
}