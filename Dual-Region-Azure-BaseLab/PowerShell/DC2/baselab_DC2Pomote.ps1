ipconfig /registerdns
Install-ADDSDomainController `
-InstallDns:$true `
-CreateDnsDelegation:$false `
-DatabasePath "E:\windows\NTDS" `
-LogPath "E:\windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "E:\windows\SYSVOL" `
-DomainName "ad.lab" `
-Force:$true `
-Credential (Get-Credential)
