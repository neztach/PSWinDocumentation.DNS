﻿function Get-WinDnsServerForwarder {
    [CmdLetBinding()]
    param(
        [string[]] $ComputerName,
        [string] $Domain = $ENV:USERDNSDOMAIN,
        [switch] $Formatted,
        [string] $Splitter = ', '
    )
    if ($Domain -and -not $ComputerName) {
        $ComputerName = (Get-ADDomainController -Filter * -Server $Domain).HostName
    }
    foreach ($Computer in $ComputerName) {
        try {
            $DnsServerForwarder = Get-DnsServerForwarder -ComputerName $Computer -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning "Get-WinDnsServerForwarder - Error $ErrorMessage"
            continue
        }
        foreach ($_ in $DnsServerForwarder) {
            if ($Formatted) {
                [PSCustomObject] @{
                    IPAddress          = $_.IPAddress.IPAddressToString -join $Splitter
                    ReorderedIPAddress = $_.ReorderedIPAddress.IPAddressToString -join $Splitter
                    EnableReordering   = $_.EnableReordering
                    Timeout            = $_.Timeout
                    UseRootHint        = $_.UseRootHint
                    GatheredFrom       = $Computer
                }
            } else {
                [PSCustomObject] @{
                    IPAddress          = $_.IPAddress.IPAddressToString
                    ReorderedIPAddress = $_.ReorderedIPAddress.IPAddressToString
                    EnableReordering   = $_.EnableReordering
                    Timeout            = $_.Timeout
                    UseRootHint        = $_.UseRootHint
                    GatheredFrom       = $Computer
                }
            }
        }
    }
}