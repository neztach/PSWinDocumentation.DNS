﻿Import-Module .\PSWinDocumentation.DNS.psd1 -Force

$DNS = Get-WinDNSInformation -ComputerName 'AD1.AD.EVOTEC.XYZ', 'AD2.AD.EVOTEC.XYZ'
#$DNS.'AD1.AD.EVOTEC.XYZ'.ServerRootHint
$DNS.'AD1.AD.EVOTEC.XYZ'.ServerRecursion | fl *


Dashboard -FilePath "$PSScriptRoot\Example-Manual.html" {
    foreach ($Server in $DNS.Keys) {
        Tab -Name $Server {
            foreach ($Setting in $DNS.$Server.Keys) {
                Section -Name $Setting {
                    Table -DataTable $DNS.$Server.$Setting -HideFooter
                }
            }
        }

    }
} -Show