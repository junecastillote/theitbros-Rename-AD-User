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
    $GivenName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $Surname,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $DisplayName,

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
    "Successfully renamed the user." | Out-Default
}
catch {
    $_.Exception.Message | Out-Default
    return $null
}


$renameParams = @{  }
if ($PSBoundParameters.ContainsKey('GivenName')) {
    $renameParams += @{GivenName = $GivenName }   
}

if ($PSBoundParameters.ContainsKey('Surname')) {
    $renameParams += @{Surname = $Surname }
}

if ($PSBoundParameters.ContainsKey('DisplayName')) {
    $renameParams += @{DisplayName = $DisplayName }
}

if ($renameParams.Keys.Count -gt 0) {
    try {
        Set-ADUser @renameParams -ErrorAction Stop -Server $Server -Identity $userObject.ObjectGUID
        "Successfully updated following attributes: [$(($renameParams.GetEnumerator().Name) -join ",")]." | Out-Default
    }
    catch {
        $_.Exception.Message | Out-Default
        # Revent the user object rename
        "Reverting the user object name" | Out-Default
        Rename-ADObject -Identity $userObject.ObjectGUID -NewName $userObject.Name -ErrorAction Stop -Server $Server
        return $null
    }
}