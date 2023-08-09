' Usage: cscript RenameADUser.vbs /OldUserDN:"CN=Christopher Wilson,OU=Users,OU=California,OU=USA,DC=theitbros,DC=com" /NewName:"Chris Wilson" /NewGivenName:"Chris" /Newsurname:"Wilson" /NewDisplayName:"Chris Wilson"
Option Explicit

Dim OldUserDN, NewName, NewGivenName, Newsurname, NewDisplayName, NewSamAccountName, NewUserPrincipalName

' Check if OldUserDN parameter is provided
If WScript.Arguments.Named.Exists("OldUserDN") Then
    OldUserDN = WScript.Arguments.Named("OldUserDN")
Else
    WScript.Echo "Missing OldUserDN parameter."
    WScript.Quit
End If

' Check if NewName parameter is provided
If WScript.Arguments.Named.Exists("NewName") Then
    NewName = WScript.Arguments.Named("NewName")
Else
    WScript.Echo "Missing NewName parameter."
    WScript.Quit
End If

' Check if NewGivenName parameter is provided
If WScript.Arguments.Named.Exists("NewGivenName") Then
    NewGivenName = WScript.Arguments.Named("NewGivenName")
End If

' Check if Newsurname parameter is provided
If WScript.Arguments.Named.Exists("Newsurname") Then
    Newsurname = WScript.Arguments.Named("Newsurname")
End If

' Check if NewDisplayName parameter is provided
If WScript.Arguments.Named.Exists("NewDisplayName") Then
    NewDisplayName = WScript.Arguments.Named("NewDisplayName")
End If

' Check if NewSamAccountName parameter is provided
If WScript.Arguments.Named.Exists("NewSamAccountName") Then
    NewSamAccountName = WScript.Arguments.Named("NewSamAccountName")
End If

' Check if NewUserPrincipalName parameter is provided
If WScript.Arguments.Named.Exists("NewUserPrincipalName") Then
    NewUserPrincipalName = WScript.Arguments.Named("NewUserPrincipalName")
End If

' Bind to the Active Directory user object
Dim objUser
On Error Resume Next
Set objUser = GetObject("LDAP://" & OldUserDN)
On Error GoTo 0

If objUser Is Nothing Then
    WScript.Echo "Failed to bind to the user object."
    WScript.Quit
End If

' Rename the user object
Dim container, newObj
Set container = GetObject(objUser.Parent)
Set newObj = container.MoveHere("LDAP://" & OldUserDN, "CN=" & NewName)

' Bind to the Active Directory user object (new name)
On Error Resume Next
Set objUser = GetObject("LDAP://" & newObj.distinguishedname)
On Error GoTo 0

If objUser Is Nothing Then
    WScript.Echo "Failed to bind to the renamed user object."
    WScript.Quit
End If

' Update optional attributes if provided
If Not NewGivenName = "" Then
    objUser.Put "givenName", NewGivenName
End If

If Not Newsurname = "" Then
    objUser.Put "sn", Newsurname
End If

If Not NewDisplayName = "" Then
    objUser.Put "displayName", NewDisplayName
End If

If Not NewSamAccountName = "" Then
    objUser.Put "samAccountName", NewSamAccountName
End If

If Not NewUserPrincipalName = "" Then
    objUser.Put "userPrincipalName", NewUserPrincipalName
End If

' Save the changes to the user object
objUser.SetInfo

' Display the new user object attributes
WScript.Echo "User object renamed and attributes updated."
WScript.Echo "======================================================"
WScript.Echo "DN:             " & objUser.distinguishedname
WScript.Echo "Name:           " & objUser.Name
WScript.Echo "Display Name:   " & objUser.displayName
WScript.Echo "Given Name:     " & objUser.givenName
WScript.Echo "Surname:        " & objUser.sn
WScript.Echo "Username:       " & objUser.samAccountName
WScript.Echo "UPN:            " & objUser.userPrincipalName
WScript.Echo "======================================================"