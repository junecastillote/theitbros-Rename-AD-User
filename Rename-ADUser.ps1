[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [Microsoft.ActiveDirectory.Management.ADUser]
    $Identity,

    [Parameter(Mandatory)]
    [String]
    $NewName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NewGivenName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NewSurname,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NewDisplayName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NewSamAccountName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NewUserPrincipalName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $Server
)

if (!$Server) {
    try {
        $Server = (Get-ADDomaincontroller -NextClosestSite -Discover -ErrorAction Stop).HostName[0]
    }
    catch {
        $_.Exception.Message | Out-Default
        return $null
    }    
}

try {
    $userObject = Get-ADUser -Identity $Identity -ErrorAction Stop -Server $Server
}
catch {
    $_.Exception.Message | Out-Default
    return $null
}

try {
    Rename-ADObject -Identity $userObject.ObjectGUID -NewName $NewName -ErrorAction Stop -Server $Server
    "Successfully renamed the user:" | Out-Default
    $userObject = Get-ADUser -Identity $Identity -ErrorAction Stop -Server $Server
    "     -> $("DN: " + $userObject.distinguishedName)" | Out-Default
    "     -> $("Name: " + $userObject.Name)" | Out-Default

}
catch {
    $_.Exception.Message | Out-Default
    return $null
}


$renameParams = @{  }
if ($PSBoundParameters.ContainsKey('NewGivenName')) {
    $renameParams += @{GivenName = $NewGivenName }   
}

if ($PSBoundParameters.ContainsKey('NewSurname')) {
    $renameParams += @{Surname = $NewSurname }
}

if ($PSBoundParameters.ContainsKey('NewDisplayName')) {
    $renameParams += @{DisplayName = $NewDisplayName }
}

if ($PSBoundParameters.ContainsKey('NewSamAccountName')) {
    $renameParams += @{SamAccountName = $NewSamAccountName }
}

if ($PSBoundParameters.ContainsKey('NewUserPrincipalName')) {
    $renameParams += @{UserPrincipalName = $NewUserPrincipalName }
}

if ($renameParams.Keys.Count -gt 0) {
    try {
        Set-ADUser @renameParams -ErrorAction Stop -Server $Server -Identity $userObject.ObjectGUID
        "Successfully updated following attributes:" | Out-Default
        foreach ($param in $renameParams.GetEnumerator()) {
            "     -> $($param.Name + ": " + $param.Value)" | Out-Default
        }
    }
    catch {
        $_.Exception.Message | Out-Default
        # Revent the user object rename
        "Reverting the user object name." | Out-Default
        Rename-ADObject -Identity $userObject.ObjectGUID -NewName $userObject.Name -ErrorAction Stop -Server $Server
        return $null
    }
}