$outputfile = "C:\temp\KeyCredentialLink-report.txt"
New-Item -ItemType file -Path $outputfile -Force | Out-Null

"Report généré le " + (Get-Date) | Out-File $outputfile 

"==== Énumération des Utilisateurs ====" | Out-File $outputfile -Append

# Énumérer tous les utilisateurs AD qui possèdent une valeur dans msDS-KeyCredentialLink
foreach ($user in (Get-ADUser -LDAPFilter '(msDS-KeyCredentialLink=*)' -Properties "msDS-KeyCredentialLink")) {
    "===========`nUser: $($user.UserPrincipalName)`nDN: $($user.DistinguishedName)" | Out-File $outputfile -Append
    "KeyCredialLink Entries:" | Out-File $outputfile -Append
    "   Source|Usage|DeviceID                            |KeyID" | Out-File $outputfile -Append
    "   -------------------------------------------------------------------" | Out-File $outputfile -Append

    foreach ($blob in ($user."msDS-KeyCredentialLink")) {
        $KCLstring = ($blob -split ':')[2]
        
        # Vérifier que l'entrée est en version 2
        if ($KCLstring.Substring(0, 8) -eq "00020000") {
            $curIndex = 8   
            # Parser toutes les entrées KeyCredentialLink depuis la chaîne hexadécimale
            while ($curIndex -lt $KCLstring.Length) {
                $strLength = ($KCLstring.Substring($curIndex, 4)) -split '(?<=\G..)(?!$)'
                [array]::Reverse($strLength)
                $kcle_Length = ([convert]::ToInt16(-join $strLength, 16)) * 2
            
                $kcle_Identifier = $KCLstring.Substring($curIndex + 4, 2)
                $kcle_Value = $KCLstring.Substring($curIndex + 6, $kcle_Length)
            
                switch ($kcle_Identifier) {
                    '01' {
                        $KeyID = $kcle_Value
                    }
                    '04' {
                        switch ($kcle_Value) {
                            '01' { $Usage = "NGC  " }
                            '07' { $Usage = "FIDO " }
                            '08' { $Usage = "FEK  " }
                            Default { $Usage = $kcle_Value }
                        }
                    }
                    '05' {
                        switch ($kcle_Value) {
                            '00' { $Source = "AD    " }
                            '01' { $Source = "Entra " }
                            Default { $Source = $kcle_Value }
                        }
                    }
                    '06' {
                        $tempByteArray = $kcle_Value -split '(?<=\G..)(?!$)'
                        $DeviceID = [System.Guid]::new($tempByteArray[3..0] + $tempByteArray[5..4] + $tempByteArray[7..6] + $tempByteArray[8..16] -join "")
                    }
                }

                $curIndex += 6 + $kcle_Length
            }

            "   $Source|$Usage|$DeviceID|$KeyID" | Out-File $outputfile -Append
        }
    }
}

"==== Énumération des Ordinateurs ====" | Out-File $outputfile -Append

# Énumérer tous les ordinateurs AD qui possèdent une valeur dans msDS-KeyCredentialLink
foreach ($computer in (Get-ADComputer -LDAPFilter '(msDS-KeyCredentialLink=*)' -Properties "msDS-KeyCredentialLink")) {
    "===========`nComputer: $($computer.Name)`nDN: $($computer.DistinguishedName)" | Out-File $outputfile -Append
    "KeyCredialLink Entries:" | Out-File $outputfile -Append
    "   Source|Usage|DeviceID                            |KeyID" | Out-File $outputfile -Append
    "   -------------------------------------------------------------------" | Out-File $outputfile -Append

    foreach ($blob in ($computer."msDS-KeyCredentialLink")) {
        $KCLstring = ($blob -split ':')[2]
        
        # Vérifier que l'entrée est en version 2
        if ($KCLstring.Substring(0, 8) -eq "00020000") {
            $curIndex = 8   
            # Parser toutes les entrées KeyCredentialLink depuis la chaîne hexadécimale
            while ($curIndex -lt $KCLstring.Length) {
                $strLength = ($KCLstring.Substring($curIndex, 4)) -split '(?<=\G..)(?!$)'
                [array]::Reverse($strLength)
                $kcle_Length = ([convert]::ToInt16(-join $strLength, 16)) * 2
            
                $kcle_Identifier = $KCLstring.Substring($curIndex + 4, 2)
                $kcle_Value = $KCLstring.Substring($curIndex + 6, $kcle_Length)
            
                switch ($kcle_Identifier) {
                    '01' {
                        $KeyID = $kcle_Value
                    }
                    '04' {
                        switch ($kcle_Value) {
                            '01' { $Usage = "NGC  " }
                            '07' { $Usage = "FIDO " }
                            '08' { $Usage = "FEK  " }
                            Default { $Usage = $kcle_Value }
                        }
                    }
                    '05' {
                        switch ($kcle_Value) {
                            '00' { $Source = "AD    " }
                            '01' { $Source = "Entra " }
                            Default { $Source = $kcle_Value }
                        }
                    }
                    '06' {
                        $tempByteArray = $kcle_Value -split '(?<=\G..)(?!$)'
                        $DeviceID = [System.Guid]::new($tempByteArray[3..0] + $tempByteArray[5..4] + $tempByteArray[7..6] + $tempByteArray[8..16] -join "")
                    }
                }

                $curIndex += 6 + $kcle_Length
            }

            "   $Source|$Usage|$DeviceID|$KeyID" | Out-File $outputfile -Append
        }
    }
}

Write-Host "Le rapport est consultable ici : $outputfile"
