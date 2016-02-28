#!powershell
# <license>

# WANT_JSON
# POWERSHELL_COMMON
param([string]$NewFQDN, [string]$NewName)

$TCPIP_PARAMS = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\"

# exit on error
$ErrorActionPreference = "Stop"

# work out Domain
$NewDomain = $NewFQDN.clone() -replace "^[^.]*.", ""

# debug info
"fqdn " + $NewFQDN + " Name  " + $NewName + " Domain " + $NewDomain

# set Domain
$OldDomain = (Get-ItemProperty -path $TCPIP_PARAMS)."Domain"

if ($OldDomain.ToUpper() -NotMatch $NewDomain.ToUpper())
{
    "Setting Domain to " + $NewDomain + " was " + $OldDomain
    Set-ItemProperty $TCPIP_PARAMS -name Domain -Value $NewDomain
    Set-ItemProperty $TCPIP_PARAMS -name "NV Domain" -Value $NewDomain
}

# set hostNewName
$OldName = (gwmi win32_computersystem -Property DNSHostName).DNSHostName

if ($OldName.ToLower().Trim() -NotMatch $NewName.ToLower().Trim())
{
    "Setting name to " + $NewName + " was " + $OldName
    Rename-Computer -NewName $NewName -Force -PassThru
}

exit $LastExitCode