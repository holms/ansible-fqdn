#!powershell
# WANT_JSON
# POWERSHELL_COMMON
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$NewFQDN,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$NewName
)

$ErrorActionPreference = 'Stop'

# Exit nonzero on runtime failures. Errors during a '&' invocation can
# otherwise leave the wrapping PowerShell process with exit code 0, which
# makes the Ansible script module report success for a failed script.
trap {
    Write-Error -ErrorRecord $_
    exit 1
}

$normalizedFqdn = $NewFQDN.Trim().TrimEnd('.')
if ($normalizedFqdn -notmatch '^[^.]+\..+$') {
    throw "NewFQDN must include a DNS suffix, for example host.example.com."
}

$newDomain = $normalizedFqdn -replace '^[^.]+\.', ''
$computer = Get-CimInstance -ClassName Win32_ComputerSystem
$currentName = $computer.DNSHostName
if ([string]::IsNullOrWhiteSpace($currentName)) {
    $currentName = $computer.Name
}

$changed = $false

if ([bool]$computer.PartOfDomain) {
    if ($computer.Domain -and $computer.Domain -ine $newDomain) {
        throw "Computer is joined to '$($computer.Domain)', which does not match FQDN domain '$newDomain'."
    }
    Write-Output "Computer is domain-joined; DNS suffix is managed by Active Directory."
}
else {
    $tcpipParams = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
    foreach ($propertyName in @('Domain', 'NV Domain')) {
        $currentValue = (Get-ItemProperty -Path $tcpipParams -Name $propertyName -ErrorAction SilentlyContinue).$propertyName
        if ($currentValue -ne $newDomain) {
            Set-ItemProperty -Path $tcpipParams -Name $propertyName -Value $newDomain
            $changed = $true
        }
    }
}

if ($currentName -ine $NewName) {
    Rename-Computer -NewName $NewName -Force -PassThru | Out-Null
    $changed = $true
}

if ($changed) {
    Write-Output 'CHANGED'
    Write-Output 'REBOOT_REQUIRED'
}
else {
    Write-Output 'UNCHANGED'
}

exit 0
