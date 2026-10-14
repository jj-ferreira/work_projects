#Visual Studio Code Shortcuts
#   Fold folds the innermost uncollapsed region at the cursor:
#       Ctrl + Shift + [ on Windows and Linux
#   Unfold unfolds the collapsed region at the cursor:
#       Ctrl + Shift + ] on Windows and Linux
#   Fold All folds all regions in the editor:
#       Ctrl + (K => 0) (zero) on Windows and Linux
#   Unfold All unfolds all regions in the editor:
#       Ctrl + (K => J) on Windows and Linux


# Copy the script into C:\Scripts\ of the server or workstation which will be used.  
# If the folder does not exist, please make it and copy the file there.
# If you want to adjust the path, remember to update how you load the script.
# Load with ". C:\Scripts\FunctionsForHomeDrive.ps1"
### DO not include the quotes. It simply tells you what the command is.  The period there is required for loading.  ###


Function Add-HomeDriveDeny {
    <#
    .SYNOPSIS
        This funtion will apply a deny ACL on the MY DOCUMENTS folder within the home drive.
   
    .DESCRIPTION
        It will deny access for the home drive owner to their my documents located in their home drive.

    .PARAMETER Office
        This is the office code.  It should be three letters such as CHI, LON, HKG, etc.

    .PARAMETER Domain
        This is our domain.  It should be formatted as AMERICAS, EMEA or ASIA.

    .PARAMETER UserTKID
        This is the SAM account name.  It should follow the pattern of AA000000.
           
    .EXAMPLE
        Add-HomeDriveDeny -Office MEX -Domain Americas -UserTKID AA000000
    #>

        Param ($Office,$Domain,$UserTKID)    
       
        if ($Office -eq $Null){Write-Host "Office value is empty.  Please provide one."; Break }
        if ($Domain -eq $Null){Write-Host "Domain value is empty.  Please provide one."; Break }
        if ($UserTKID -eq $Null){Write-Host "UserTKID value is empty.  Please provide one."; Break }

        if($Office -eq "CHA"){ $folderPath = "\\ame-fs01\CHAhome"; }
        elseif($Office -eq "CHI"){ $folderPath = "\\ame-fs01\CHIhome"; }
        elseif($Office -eq "HOU"){ $folderPath = "\\ame-fs01\HOUhome"; }
        elseif($Office -eq "LOS"){ $folderPath = "\\ame-fs01\LOShome"; }
        elseif($Office -eq "MEX"){ $folderPath = "\\ame-fs01\MEXhome"; }
        elseif($Office -eq "NYC"){ $folderPath = "\\ame-fs01\NYChome"; }
        elseif($Office -eq "PAL"){ $folderPath = "\\ame-fs01\PALhome"; }
        elseif($Office -eq "SFO"){ $folderPath = "\\ame-fs01\SFOhome"; }
        elseif($Office -eq "SLC"){ $folderPath = "\\ame-fs01\SLChome"; }
        elseif($Office -eq "WDC"){ $folderPath = "\\ame-fs01\WDChome"; }
        elseif($Office -eq "WVA"){ $folderPath = "\\ame-fs01\WVAhome"; }
        elseif($Office -eq "BGK"){ $folderPath = "\\asi-fs01\BGKhome"; }
        elseif($Office -eq "BJG"){ $folderPath = "\\asi-fs01\BJGhome"; }
        elseif($Office -eq "HCM"){ $folderPath = "\\asi-fs01\HCMhome"; }
        elseif($Office -eq "HKG"){ $folderPath = "\\asi-fs01\HKGhome"; }
        elseif($Office -eq "HNI"){ $folderPath = "\\asi-fs01\HNIhome"; }
        elseif($Office -eq "PKW"){ $folderPath = "\\asi-fs01\PKWhome"; }
        elseif($Office -eq "SGP"){ $folderPath = "\\asi-fs01\SGPhome"; }
        elseif($Office -eq "SHI"){ $folderPath = "\\asi-fs01\SHIhome"; }
        elseif($Office -eq "TYO"){ $folderPath = "\\asi-fs01\TYOhome"; }
        elseif($Office -eq "BRU"){ $folderPath = "\\eme-fs01\BRUhome"; }
        elseif($Office -eq "DUB"){ $folderPath = "\\eme-fs01\DUBhome"; }
        elseif($Office -eq "DUS"){ $folderPath = "\\eme-fs01\DUShome"; }
        elseif($Office -eq "FRK"){ $folderPath = "\\eme-fs01\FRKhome"; }
        elseif($Office -eq "LON"){ $folderPath = "\\eme-fs01\LONhome"; }
        elseif($Office -eq "PAR"){ $folderPath = "\\eme-fs01\PARhome"; }
elseif($Office -eq "FRK"){ $folderPath = "\\eme-fs01\FRKhome"; }
        elseif($Office -eq "BSB"){ $folderPath = "\\sam-pdfs01\BSBhome"; }
        elseif($Office -eq "RIO"){ $folderPath = "\\sam-pdfs01\RIOhome"; }
        elseif($Office -eq "SAP"){ $folderPath = "\\sam-pdfs01\SAPhome"; }
        elseif($Office -eq "VIT"){ $folderPath = "\\sam-pdfs01\VIThome"; }
        else{ Write-Host "Provided Office does not Exist.  Please use one of our standard 3 letter code names."; Break}

        if(($Domain -ne "Americas") -and ($Domain -ne "EMEA") -and ($Domain -ne "Asia") ){ Write-Host "Provided Domain may not be correct."; Break}

        $HomeDrivePath = "$folderPath\$UserTKID\My Documents"

        #$acl = (Get-Item $HomeDrivePath).GetAccessControl('Access')
        $NewAcl = (get-acl $HomeDrivePath)

        # Generate DENY property
        $identity = "$Domain\$UserTKID"
        $fileSystemRights = "FullControl"
        $type = "Deny"
        $inheritance = 'ContainerInherit, ObjectInherit'

        # $permission = $env:username, 'Read,Modify', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
        $fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritance, 'None', $type
            $newParams = @{
                TypeName     = 'System.Security.AccessControl.FileSystemAccessRule'
                ArgumentList = $fileSystemAccessRuleArgumentList
            }

        $fileSystemAccessRule = New-Object @newParams
        $NewAcl.SetAccessRule($fileSystemAccessRule)
        Set-Acl -Path $HomeDrivePath -AclObject $NewAcl
        $acesToRemove = $newacl.Access | where-object { $_.IsInherited -eq $false -and $_.IdentityReference -eq "$Domain\$UserTKID" -and $_.FileSystemRights -eq "FullControl" -and $_.AccessControlType -eq "Deny" }

        if (($acesToRemove).count -eq 1){Write-Host "DENY permission for $Domain\$UserTKID on $HomeDrivePath is now present."}
        else {Write-Host "Something may have gone wrong for $Domain\$UserTKID on $HomeDrivePath."}

}



Function Remove-HomeDriveDeny {
    <#
    .SYNOPSIS
        This funtion will remove a deny ACL on the MY DOCUMENTS folder within the home drive.
   
    .DESCRIPTION
        It will restore access for the home drive owner to their my documents located in their home drive.

    .PARAMETER Office
        This is the office code.  It should be three letters such as CHI, LON, HKG, etc.

    .PARAMETER Domain
        This is our domain.  It should be formatted as AMERICAS, EMEA or ASIA.

    .PARAMETER UserTKID
        This is the SAM account name.  It should follow the pattern of AA000000.
           
    .EXAMPLE
        Add-HomeDriveDeny -Office MEX -Domain Americas -UserTKID AA000000
    #>

        Param ($Office,$Domain,$UserTKID)    
       
        if ($Office -eq $Null){Write-Host "Office value is empty.  Please provide one."; Break }
        if ($Domain -eq $Null){Write-Host "Domain value is empty.  Please provide one."; Break }
        if ($UserTKID -eq $Null){Write-Host "UserTKID value is empty.  Please provide one."; Break }
        #write-host "1"
        $FullControllCheck = 0
        $ModifyCheck = 0
        #write-host "2 $Office"
        if($Office -eq "CHA"){ $folderPath = "\\ame-fs01\CHAhome"; }
        elseif($Office -eq "CHI"){ $folderPath = "\\ame-fs01\CHIhome"; }
        elseif($Office -eq "HOU"){ $folderPath = "\\ame-fs01\HOUhome"; }
        elseif($Office -eq "LOS"){ $folderPath = "\\ame-fs01\LOShome"; }
        elseif($Office -eq "MEX"){ $folderPath = "\\ame-fs01\MEXhome"; }
        elseif($Office -eq "NYC"){ $folderPath = "\\ame-fs01\NYChome"; }
        elseif($Office -eq "PAL"){ $folderPath = "\\ame-fs01\PALhome"; }
        elseif($Office -eq "SFO"){ $folderPath = "\\ame-fs01\SFOhome"; }
        elseif($Office -eq "SLC"){ $folderPath = "\\ame-fs01\SLChome"; }
        elseif($Office -eq "WDC"){ $folderPath = "\\ame-fs01\WDChome"; }
        elseif($Office -eq "WVA"){ $folderPath = "\\ame-fs01\WVAhome"; }
        elseif($Office -eq "BGK"){ $folderPath = "\\asi-fs01\BGKhome"; }
        elseif($Office -eq "BJG"){ $folderPath = "\\asi-fs01\BJGhome"; }
        elseif($Office -eq "HCM"){ $folderPath = "\\asi-fs01\HCMhome"; }
        elseif($Office -eq "HKG"){ $folderPath = "\\asi-fs01\HKGhome"; }
        elseif($Office -eq "HNI"){ $folderPath = "\\asi-fs01\HNIhome"; }
        elseif($Office -eq "PKW"){ $folderPath = "\\asi-fs01\PKWhome"; }
        elseif($Office -eq "SGP"){ $folderPath = "\\asi-fs01\SGPhome"; }
        elseif($Office -eq "SHI"){ $folderPath = "\\asi-fs01\SHIhome"; }
        elseif($Office -eq "TYO"){ $folderPath = "\\asi-fs01\TYOhome"; }
        elseif($Office -eq "BRU"){ $folderPath = "\\eme-fs01\BRUhome"; }
        elseif($Office -eq "DUB"){ $folderPath = "\\eme-fs01\DUBhome"; }
        elseif($Office -eq "DUS"){ $folderPath = "\\eme-fs01\DUShome"; }
        elseif($Office -eq "FRK"){ $folderPath = "\\eme-fs01\FRKhome"; }
        elseif($Office -eq "LON"){ $folderPath = "\\eme-fs01\LONhome"; }
        elseif($Office -eq "PAR"){ $folderPath = "\\eme-fs01\PARhome"; }
        elseif($Office -eq "BSB"){ $folderPath = "\\sam-pdfs01\BSBhome"; }
        elseif($Office -eq "RIO"){ $folderPath = "\\sam-pdfs01\RIOhome"; }
        elseif($Office -eq "SAP"){ $folderPath = "\\sam-pdfs01\SAPhome"; }
        elseif($Office -eq "VIT"){ $folderPath = "\\sam-pdfs01\VIThome"; }
        else{ Write-Host "Provided Office does not Exist.  Please use one of our standard 3 letter code names."; Break}
        #write-host "3"
        if(($Domain -ne "Americas") -and ($Domain -ne "EMEA") -and ($Domain -ne "Asia") ){ Write-Host "Provided Domain may not be correct."; Break}
        #write-host "4"


        $HomeDrivePath = "$folderPath\$UserTKID\My Documents"
        #write-host "5"

        $acl = (Get-Item $HomeDrivePath).GetAccessControl('Access')
        # Below - Commented out, but can be used for troubleshooting to see ACLs.
        # $acl | Format-List

        <# SAMPLE
            FileSystemRights  : FullControl
            AccessControlType : Allow
            IdentityReference : AMERICAS\AA000000
            IsInherited       : False
            InheritanceFlags  : None
            PropagationFlags  : None
        #>

        $acesToRemove = $acl.Access | where-object { $_.IsInherited -eq $false -and $_.IdentityReference -eq "$Domain\$UserTKID" -and $_.FileSystemRights -eq "FullControl" -and $_.AccessControlType -eq "Deny" }
        $FullControllCheck = ($acesToRemove).count
        if ($FullControllCheck -eq 1) {
            $acl.RemoveAccessRuleAll($acesToRemove);
            Set-Acl -AclObject $acl -path "$HomeDrivePath"
           
        }
        #write-host "6"
        $acesToRemove = $acl.Access | where-object { $_.IsInherited -eq $false -and $_.IdentityReference -eq "$Domain\$UserTKID" -and $_.FileSystemRights -eq "FullControl" -and $_.AccessControlType -eq "Deny" }


        if (($acesToRemove).count -eq 0){Write-Host "DENY permission for $Domain\$UserTKID on $HomeDrivePath has been removed."}
        else {Write-Host "Something may have gone wrong for $Domain\$UserTKID on $HomeDrivePath."}


}