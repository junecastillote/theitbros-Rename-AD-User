# VB Script
cscript.exe //nologo RenameADUser.vbs /OldUserDN:"CN=Christopher Wilson,OU=Users,OU=California,OU=USA,DC=theitbros,DC=com" /NewName:"Chris Wilson" /NewGivenName:"Chris" /NewSurName:"Wilson" /NewDisplayName:"Chris Wilson"
cscript.exe //nologo RenameADUser.vbs /OldUserDN:"CN=Olivia Hill,OU=Users,OU=California,OU=USA,DC=theitbros,DC=com" /NewName:"Olive Douglas" /NewGivenName:"Olive" /NewSurName:"Douglas" /NewDisplayName:"Olive Douglas" /NewSamAccountName:"odouglas" /NewUserPrincipalName:"odouglas@theitbros.com"
cscript.exe //nologo RenameADUser.vbs /OldUserDN:"CN=Olive Douglas,OU=Users,OU=California,OU=USA,DC=theitbros,DC=com" /NewName:"Olivia Hill" /NewGivenName:"Olivia" /NewSurName:"Hill" /NewDisplayName:"Olivia Hill" /NewSamAccountName:"ohill" /NewUserPrincipalName:"ohill@theitbros.com"

# PowerShell Script
.\Rename-ADUser.ps1 -Identity cwilson -NewName 'Chris Wilson' -NewGivenName "Chris" -NewDisplayName "Chris Wilson"


.\Rename-ADUser.ps1 -Identity ohill `
    -NewName 'Olive Douglas' `
    -NewGivenName 'Olive' `
    -NewSurname 'Douglas' `
    -NewDisplayName 'Olive Douglas' `
    -NewSamAccountName 'odouglas' `
    -NewUserPrincipalName 'odouglas@theitbros.com'

.\Rename-ADUser.ps1 -Identity odouglas `
    -NewName 'Olivia Hill' `
    -NewGivenName 'Olivia' `
    -NewSurname 'Hill' `
    -NewDisplayName 'Olivia Hill' `
    -NewSamAccountName 'ohill' `
    -NewUserPrincipalName 'ohill@theitbros.com'