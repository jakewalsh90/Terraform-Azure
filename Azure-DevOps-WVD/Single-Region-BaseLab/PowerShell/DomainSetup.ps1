$password = ConvertTo-SecureString '__vmpassword__' -AsPlainText -Force
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "E:\windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "ad.lab" `
-DomainNetbiosName "ad" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "E:\windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "E:\windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword: $password