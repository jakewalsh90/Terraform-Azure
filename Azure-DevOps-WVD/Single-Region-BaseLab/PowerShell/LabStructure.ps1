#Setup Variables
$DCRoot = "DC=ad,DC=lab"
$LabDCRoot = "OU=Lab,DC=ad,DC=Lab"
#Create Root Lab OU
New-ADOrganizationalUnit -Name "Lab" -Path $DCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab Environment"
#Create Other OUs
New-ADOrganizationalUnit -Name "Users" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab Users"
New-ADOrganizationalUnit -Name "Service Accounts" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab Service Accounts"
New-ADOrganizationalUnit -Name "Servers" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab Servers"
New-ADOrganizationalUnit -Name "WVD" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab WVD Session Hosts"
New-ADOrganizationalUnit -Name "Computers" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab Computers"
New-ADOrganizationalUnit -Name "ANF" -Path $LabDCRoot -ProtectedFromAccidentalDeletion $False -Description "Lab ANF Objects"