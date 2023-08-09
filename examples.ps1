# VB Script
cscript demo.vbs /OldUserDN:"CN=Christopher Wilson,OU=Users,OU=California,OU=USA,DC=theitbros,DC=com" /NewName:"Chris Wilson" /NewGivenName:"Chris" /NewSurName:"Wilson" /NewDisplayName:"Chris Wilson"

# PowerShell Script
.\Rename-ADUser.ps1 -Identity cwilson -NewName 'Chris Wilson' -GivenName "Chris" -DisplayName "Chris Wilson"