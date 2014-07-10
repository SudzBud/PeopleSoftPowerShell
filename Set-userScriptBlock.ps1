
#REGION Set-ksPSAdUserSB
##TODO Add Departure appropriate date values (e.g. Mail end date, Account end date, etc.)(embedded ScriptBlock)

function Set-ksPSAdUser($userObj){
    $adproperties = 'displayname','mobile','facsimileTelephoneNumber','division','department','office','title','manager','company','streetaddress',`
    'city','state','postalcode','officephone','personaltitle','middlename','msexchassistantname','generationqualifier','extensionattribute1',`
    'extensionattribute2','extensionattribute3','extensionattribute4','extensionattribute5','extensionattribute6','extensionattribute7',`
    'extensionattribute8','extensionattribute9','extensionattribute10','extensionattribute11','extensionattribute12','extensionattribute13',`
    'extensionattribute14','extensionattribute15'
	[string]$Name = $userObj.LOGIN
	[string]$surname = $userObj.surname
	[string]$givenname = $userObj.givenname
	[string]$middlename = $userObj.middlename
	[string]$displayname = $userObj.displayName
	[string]$generationQualifier = $userObj.GenerationQualifier
	[string]$personalTitle = $userObj.PersonalTitle
	[string]$telephonenumber = $userObj.telephonenumber
	[string]$mobile = $userObj.mobile
	[string]$FacsimileTelephoneNumber = $userObj.FacsimileTelephoneNumber
	[string]$company = $userObj.Company
	[string]$division = $userObj.Division
	[string]$department = $userObj.Department
	[string]$Office = $userObj.office
	[string]$title = $userObj.title
	[string]$manager = $userObj.manager
	[string]$msExchAssistantName = $userObj.msExchAssistantName
	[string]$OUpath = $userObj.OUpath
	[string]$extensionAttribute1 = $userObj.ExtensionAttribute1
	[string]$extensionAttribute2 = $userObj.ExtensionAttribute2
	[string]$extensionAttribute3 = $userObj.ExtensionAttribute3
	[string]$extensionAttribute4 = $userObj.ExtensionAttribute4
	[string]$extensionAttribute5 = $userObj.ExtensionAttribute5
	[string]$extensionAttribute6 = $userObj.ExtensionAttribute6
	[string]$extensionAttribute9 = $userObj.ExtensionAttribute9
	[string]$extensionAttribute12 = $userObj.ExtensionAttribute12
	[string]$extensionAttribute13 = $userObj.ExtensionAttribute13
	[string]$extensionAttribute14 = $userObj.ExtensionAttribute14
	[string]$streetAddress = $userObj.streetAddress
	[string]$city = $userObj.city
	[string]$state = $userObj.state
	[string]$postalcode = $userObj.postalcode
	[string]$country = $userObj.Country
	[string]$officePhone = $userObj.officePhone
	[string]$OUpath = $userObj.OUpath
	[string]$suggestedAlias = $userObj.suggestedAlias
	[string]$userPrincipalName = $userObj.suggestedAlias + "@kurtsalmon.com"
	[string]$InFile = $userObj.InFile
	[string]$recordNum = $userObj.RecordNum
	[string]$password = $userObj.PASSWORD
	[string]$MBXdatabase = $userObj.MBXdatabase
	$effectiveDate = [datetime]::ParseExact($userObj.EFFDT,”yyyyMMdd”,$null)
	$creationDate = [datetime]::ParseExact($userObj.CREATED_DTTM,”yyyyMMdd”,$null)
	
	switch($userObj.I_ROW_FLAG){
		("C"){[string]$action = "Create"}
		("M"){[string]$action = "Modify"}
		("S"){[string]$action = "Depart"}
	}
	
	if($userObj.LOGIN){[string]$userName = $userObj.LOGIN} else {[string]$userName = $userObj.suggestedAlias}
	$mailString = $userObj.MailExist
	$accountString = $userObj.AccountExist
	if ($userObj.flag){$warnFlag = "### WARNING MESSAGES BELOW ###"}
	$warningMessage = $userObj.Warning
	
	if ($action -eq "Create"){
		$CreateUserCMD += "`$AccountPassword = `$(convertTo-SecureString `"$password`" -AsPlainText -Force)`n"
		$CreateUserCMD += "New-ADUser -Name `"$displayName`" -SAMAccountName `"$suggestedAlias`" -UserPrincipalName `"$userPrincipalName`" -AccountPassword `$AccountPassword -Enabled `$True -Path `"$OUpath`" -Credential `$AdminCred -OtherAttributes @{extensionattribute2 = `"$extensionAttribute2`"} -whatif `n"
		$CreateUserCMD += "Enable-Mailbox `"$suggestedAlias`" -Database `"$MBXdatabase`" -whatif `n"
		$CreateUserCMD += "Set-Mailbox `"$suggestedAlias`" -scljunkenabled:`$true -scljunkthreshold:4 -whatif"
		$getUserObjectCMD = "`$userObject = Get-ADUser `"$suggestedAlias`"`n"
	} else {$getUserObjectCMD = "`$userObject = Get-ADUser -filter {extensionAttribute2 -eq $extensionAttribute2}`n"}
	
	#Create Primary Attributes Command
	if ($displayName -ne ""){$primaryAttributeCMD += "#`$userObject | Set-ADUser -displayName:`"$displayName`" -Credential `$AdminCred`n"}
	if ($givenname -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -givenname:`"$givenname`" -Credential `$AdminCred`n"}
	if ($surName -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -surname:`"$surName`" -Credential `$AdminCred`n"}
	if ($mobile -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -mobile:`"$mobile`" -Credential `$AdminCred`n"}
	if ($FacsimileTelephoneNumber -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -fax:`"$FacsimileTelephoneNumber`" -Credential `$AdminCred`n"}
	if ($Division -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Division:`"$Division`" -Credential `$AdminCred`n"}
	if ($Department -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Department:`"$Department`" -Credential `$AdminCred`n"}
	if ($Office -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Office:`"$Office`" -Credential `$AdminCred`n"}
	if ($title -ne ""){$primaryAttributeCMD += "#`$userObject | Set-ADUser -title:`"$title`" -Credential `$AdminCred`n"}
	if ($manager -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -manager:`"$manager`" -Credential `$AdminCred`n"}
	if ($Company -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Company:`"$Company`" -Credential `$AdminCred`n"}
	if ($streetAddress -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -streetAddress:`"$streetAddress`" -Credential `$AdminCred`n"}
	if ($city -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -city:`"$city`" -Credential `$AdminCred`n"}
	if ($state -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -state:`"$state`" -Credential `$AdminCred`n"}
	if ($postalcode -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -postalcode:`"$postalcode`" -Credential `$AdminCred`n"}
	if ($Country -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Country:`"$Country`" -Credential `$AdminCred`n"}
	if ($telephonenumber -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -officePhone:`"$telephonenumber`" -Credential `$AdminCred`n"}

	#Create Secondary Attributes Command
	if ($personalTitle -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{personaltitle = `"$personalTitle`"}`n"}
	if ($middlename -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{middlename = `"$middlename`"}`n"}
	if ($msExchAssistantName -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{msexchassistantname = `"$msExchAssistantName`"}`n"}
	if ($generationQualifier -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{generationqualifier = `"$generationQualifier`"}`n"}
	if ($extensionAttribute1 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute1 = `"$extensionAttribute1`"}`n"}
	if ($extensionAttribute3 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute3 = `"$extensionAttribute3`"}`n"}
	if ($extensionAttribute4 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute4 = `"$extensionAttribute4`"}`n"}
	if ($extensionAttribute5 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute5 = `"$extensionAttribute5`"}`n"}
	if ($extensionAttribute6 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute6 = `"$extensionAttribute6`"}`n"}
	if ($extensionAttribute9 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute9 = `"$extensionAttribute9`"}`n"}
	if ($extensionAttribute12 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute12 = `"$extensionAttribute12`"}`n"}
	if ($extensionAttribute13 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute13 = `"$extensionAttribute13`"}`n"}
	if ($extensionAttribute14 -ne "") {$secondaryAttributeCMD += "`$userObject | Set-ADUser -Credential `$AdminCred -add @{extensionattribute14 = `"$extensionAttribute14`"}`n"}

	#Get Attributes to be changed for logging
	if ($action -ne "Create"){
    $aduserobject = Get-ADUser -filter {extensionAttribute2 -eq $extensionAttribute2} -Properties $adproperties
	$attributesToChange = @()
	$attribsChgHeader = "###############ATTRIBUTES THAT WILL CHANGE###############"
	if (!(Compare-ValuesEmptyNullEqual $displayName $aduserObject.displayName)){$attributesToChange += "DisplayName"}
	if (!(Compare-ValuesEmptyNullEqual $givenname $aduserObject.givenname)){$attributesToChange += "givenName"}
	if (!(Compare-ValuesEmptyNullEqual $surName $aduserObject.surname)){$attributesToChange += "surName"}
	if (!(Compare-ValuesEmptyNullEqual $mobile $aduserObject.mobile)){$attributesToChange += "Mobile"}
	if (!(Compare-ValuesEmptyNullEqual $FacsimileTelephoneNumber $aduserObject.FacsimileTelephoneNumber)){$attributesToChange += "FacsimileTelephoneNumber"}
	if (!(Compare-ValuesEmptyNullEqual $Division $aduserObject.Division)){$attributesToChange += "Division"}
	if (!(Compare-ValuesEmptyNullEqual $Department $aduserObject.Department)){$attributesToChange += "Department"}
	if (!(Compare-ValuesEmptyNullEqual $Office $aduserObject.Office)){$attributesToChange += "Office"}
	if (!(Compare-ValuesEmptyNullEqual $title $aduserObject.title)){$attributesToChange += "title"}
	if (!(Compare-ValuesEmptyNullEqual $manager $aduserObject.manager)){$attributesToChange += "manager"}
	if (!(Compare-ValuesEmptyNullEqual $Company $aduserObject.Company)){$attributesToChange += "Company"}
	if (!(Compare-ValuesEmptyNullEqual $streetAddress $aduserObject.streetAddress)){$attributesToChange += "streetAddress"}
	if (!(Compare-ValuesEmptyNullEqual $city $aduserObject.city)){$attributesToChange += "city"}
	if (!(Compare-ValuesEmptyNullEqual $state $aduserObject.state)){$attributesToChange += "state"}
	if (!(Compare-ValuesEmptyNullEqual $postalcode $aduserObject.postalcode)){$attributesToChange += "postalcode"}
	if (!(Compare-ValuesEmptyNullEqual $Country $aduserObject.Country)){$attributesToChange += "Country"}
	if (!(Compare-ValuesEmptyNullEqual $telephonenumber $aduserObject.officePhone)){$attributesToChange += "officePhone"}
	if (!(Compare-ValuesEmptyNullEqual $personalTitle $aduserObject.personalTitle)){$attributesToChange += "personalTitle"}
	if (!(Compare-ValuesEmptyNullEqual $middlename $aduserObject.middlename)){$attributesToChange += "middlename"}
	if (!(Compare-ValuesEmptyNullEqual $msExchAssistantName $aduserObject.msExchAssistantName)){$attributesToChange += "msExchAssistantName"}
	if (!(Compare-ValuesEmptyNullEqual $generationQualifier $aduserObject.generationQualifier)){$attributesToChange += "generationQualifier"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute1 $aduserObject.extensionAttribute1)){$attributesToChange += "extensionAttribute1"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute3 $aduserObject.extensionAttribute3)){$attributesToChange += "extensionAttribute3"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute4 $aduserObject.extensionAttribute4)){$attributesToChange += "extensionAttribute4"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute5 $aduserObject.extensionAttribute5)){$attributesToChange += "extensionAttribute5"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute6 $aduserObject.extensionAttribute6)){$attributesToChange += "extensionAttribute6"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute9 $aduserObject.extensionAttribute9)){$attributesToChange += "extensionAttribute9"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute12 $aduserObject.extensionAttribute12)){$attributesToChange += "extensionAttribute12"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute13 $aduserObject.extensionAttribute13)){$attributesToChange += "extensionAttribute13"}
	if (!(Compare-ValuesEmptyNullEqual $extensionAttribute14 $aduserObject.extensionAttribute14)){$attributesToChange += "extensionAttribute14"}
	}
if (($attributesToChange -ne $null) -or ($action -eq "Create")){	
$cmd = @"

############################
#REGION $action $userName

###SCRIPTBLOCK to $action user object $userName###
###If this is a create action the -whatif option will need to be removed from New-ADUser and Enable-Mailbox commands
###Effective Date: $effectiveDate
###PeopleSoft Creation Date: $creationDate
$warnFlag
$warningMessage
###$mailString
###$AccountString
$attribsChgHeader
###$attributesToChange

#Get Administrator credential to run Set-ADUser Commands
if (!(`$AdminCred)){`$AdminCred = Get-Credential}

#Create user object (when Action is create *Remove -whatif switch on New-ADUser command*)
$CreateUserCMD

#Get user object
$getUserObjectCMD

#Clear Attributes
`$userObject | Set-ADUser -clear extensionattribute1 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute3 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute4 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute5 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute6 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute9 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute12 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute13 -Credential `$AdminCred
`$userObject | Set-ADUser -clear extensionattribute14 -Credential `$AdminCred
`$userObject | Set-ADUser -clear personalTitle -Credential `$AdminCred
`$userObject | Set-ADUser -clear middleName -Credential `$AdminCred
`$userObject | Set-ADUser -clear telephonenumber -Credential `$AdminCred
`$userObject | Set-ADUser -clear mobile -Credential `$AdminCred
`$userObject | Set-ADUser -clear FacsimileTelephoneNumber -Credential `$AdminCred
`$userObject | Set-ADUser -clear Division -Credential `$AdminCred
`$userObject | Set-ADUser -clear Department -Credential `$AdminCred
`$userObject | Set-ADUser -clear PhysicalDeliveryOfficeName -Credential `$AdminCred
#`$userObject | Set-ADUser -clear title -Credential `$AdminCred
`$userObject | Set-ADUser -clear manager -Credential `$AdminCred
`$userObject | Set-ADUser -clear msExchAssistantName -Credential `$AdminCred
`$userObject | Set-ADUser -clear Company -Credential `$AdminCred
`$userObject | Set-ADUser -clear generationQualifier -Credential `$AdminCred

#Set Attributes
$primaryAttributeCMD

#Set Secondary Attributes
$secondaryAttributeCMD

`$userObject = `$Null

#ENDREGION $action $userName
############################

"@
}else{
$cmd = @"

############################
#REGION $action $userName

###SCRIPTBLOCK to $action user object $userName###
###If this is a create action the -whatif option will need to be removed from New-ADUser and Enable-Mailbox commands
###Effective Date: $effectiveDate
###PeopleSoft Creation Date: $creationDate
$warnFlag
$warningMessage
###$mailString
###$AccountString
$attribsChgHeader
###$attributesToChange

`$userObject = `$Null

#ENDREGION $action $userName
############################

"@
}
	$action = $null
 	$sb = [scriptblock]::create($cmd)
 	$sb
}
#ENDREGION Set-ksPSAdUserSB

# SIG # Begin signature block
# MIINxQYJKoZIhvcNAQcCoIINtjCCDbICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZ6kc186nxgO/HihQcPg/y9uG
# Yo6gggu5MIIFoDCCBIigAwIBAgIKRJHmZwAAAAAg7TANBgkqhkiG9w0BAQUFADBI
# MRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYKa3VydHNhbG1v
# bjEVMBMGA1UEAxMMS1NHIFN1YkNBIDAxMB4XDTEzMTExMjEzMDIyNVoXDTE0MTEx
# MjEzMDIyNVowfDETMBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixkARkW
# Cmt1cnRzYWxtb24xEjAQBgNVBAsTCUVtcGxveWVlczELMAkGA1UECxMCTkExEjAQ
# BgNVBAsTCUNvcnBvcmF0ZTEUMBIGA1UEAxMLUG9ydGVyLCBCdWQwgZ8wDQYJKoZI
# hvcNAQEBBQADgY0AMIGJAoGBALMUSEy7AfW4Hhol+xAgWn6Mx+XJMPOOLtK000Rv
# RVoLsY81wFV+x5mk3DXpioN3+NYd8Tfx352cM7jR+L0Tf/c8jKJO95DMr/nHFUzV
# MllJsMfKkA66AhSrQqIQg/ABRhfzykbFtA9wfBLY8bnxSHUe8GoRaMBSc2G+yF8i
# rolFAgMBAAGjggLaMIIC1jAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBpAGcA
# bgBpAG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzALBgNVHQ8EBAMCB4AwMAYDVR0R
# BCkwJ6AlBgorBgEEAYI3FAIDoBcMFVJCUE9SVEBrdXJ0c2FsbW9uLmNvbTAdBgNV
# HQ4EFgQUXEOvQatL66iDCC0QXLPSy7pe/mowHwYDVR0jBBgwFoAU2ageMxIEErvz
# ou9q8+gdPYcUScIwggFPBgNVHR8EggFGMIIBQjCCAT6gggE6oIIBNoaBumxkYXA6
# Ly8vQ049S1NHJTIwU3ViQ0ElMjAwMSxDTj1uYXN1YmNhLENOPUNEUCxDTj1QdWJs
# aWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
# LERDPWt1cnRzYWxtb24sREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/
# YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludIY9aHR0cDovL25h
# c3ViY2Eua3VydHNhbG1vbi5jb20vQ2VydEVucm9sbC9LU0clMjBTdWJDQSUyMDAx
# LmNybIY4aHR0cDovL25hc3ViY2Eua3VydHNhbG1vbi5jb20vQ1JML0tTRyUyMFN1
# YkNBJTIwMDEvLy5jcmwwgcUGCCsGAQUFBwEBBIG4MIG1MIGyBggrBgEFBQcwAoaB
# pWxkYXA6Ly8vQ049S1NHJTIwU3ViQ0ElMjAwMSxDTj1BSUEsQ049UHVibGljJTIw
# S2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1r
# dXJ0c2FsbW9uLERDPWNvbT9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9
# Y2VydGlmaWNhdGlvbkF1dGhvcml0eTANBgkqhkiG9w0BAQUFAAOCAQEADr4w9Wv7
# GMZ3Gg0TJan1ndgM8EUNIsgTr8MPqBFxrTDBIyQINT/HyegvgMS6JqDlSKMchDaN
# bnZ2xHp/5Pb0xVlIiA+Tl3zVjEeCP3mLwCwuc6PEZSGLGMlFQWqluR+5FdOglAt2
# gpm+W1AEW314Yd0BPwGgJqwTeEYZB1Z9+AE7KbxmqssNkyvf814z2WpFjcA1KlrA
# T4h5gvNyPglrS+FkrJV/+ImqW4QkPEwUmM1D4in7oh1VSNk2emo0p9gtUPm0GctY
# nFpghKjXsdi2Dwsb8OBjMV5OGBlUaeN7jGhEsifERDmOrHCD6avDDg8tKRZkmJzp
# NDmU6t8hT0KbADCCBhEwggP5oAMCAQICCmEy4DsAAAAAAAIwDQYJKoZIhvcNAQEF
# BQAwRzETMBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixkARkWCmt1cnRz
# YWxtb24xFDASBgNVBAMTC0tTRyBSb290IENBMB4XDTExMTEyMzE2MDA1MFoXDTE5
# MTEyMzE2MTA1MFowSDETMBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixk
# ARkWCmt1cnRzYWxtb24xFTATBgNVBAMTDEtTRyBTdWJDQSAwMTCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAMqDiZEWLPpBIQZrldvJx+9Do82oj1JPuYuh
# CuMu4nIozBYSfNcNeP6YihxGggBkifK0lmfkC0yjFTUiJMoTn0bED9DWAEi5nVG/
# sFVPmFN4SJzwSr1fv5yTi6QUt1PPEadLXfwjYdNpGlblkxnrz7BVoL1kYe++iKe7
# KyoSNx7ip4pCB/+2dpv6Dl9XEmVIKcqMoVt5ev/CCLy6r7nWLfFvTTzsXfqxmgps
# qxQFt0QHwkSnAZgwUF1lMOPAOnRi80wS76LIFIFTS2HW/GxKbGpcexZ7/f9WBw50
# ZQjdMCVHc8IxOfLG3ZLanDtvNiJXrwOGtQalpvxEqAj9PAgB2lECAwEAAaOCAfww
# ggH4MBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTZqB4zEgQSu/Oi72rz6B09
# hxRJwjAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBQSRHgX/L3Ean1d8O2fHVKThd0E8DCC
# AQsGA1UdHwSCAQIwgf8wgfyggfmggfaGOWh0dHA6Ly9rc2dwa2kua3VydHNhbG1v
# bi5jb20vQ2VydERhdGEvS1NHJTIwUm9vdCUyMENBLmNybIaBuGxkYXA6Ly8vQ049
# S1NHJTIwUm9vdCUyMENBLENOPW5hcm9vdCxDTj1DRFAsQ049UHVibGljJTIwS2V5
# JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1rdXJ0
# c2FsbW9uLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2Jq
# ZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwXAYIKwYBBQUHAQEEUDBOMEwG
# CCsGAQUFBzAChkBodHRwOi8va3NncGtpLmt1cnRzYWxtb24uY29tL0NlcnREYXRh
# L25hcm9vdF9LU0clMjBSb290JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4ICAQBs
# elcxt1FDHAKB9iLz6+axl+lfFLalMcvtt5W1vbP+Y585iFfmX2ij5gy7pJ2Si+BF
# F5BcPwKKiumcOD9UM0gcp2d3geKBurdIoPWUOecTyPJaqsEhBt7YIWK0cKhBCCIS
# tlg1qeKzRdMmL91U33RSSY39slRJynL+67XpALRdqTNIl98s9fz9+KxdS4lD4gv8
# V87pqWnf8sHBW4kCX13zqHUaIIKITmYKchk0jTt+A3lTULAZ3jm3jk8ji3Ti3bwe
# nC/n4sWv9WNcg4tYxG71LZAACzw5MyiMm2PyfEi6NBf/dn1POg2cS4bjdPulAycN
# WgCF1sHo4z5r+gX5b8kch/sHA5OW104t5dHpwySyqHSeO9wY6fAuckWt44TCxSEy
# 01/YJhR/CuSqJ2YLka4Jt0EHD0l1pMDc+CdQxY1CZapX/bhRoL2sb8jQ8Po/HEWh
# /F9bz68Xa4MF07ms+rF4HXFPAn9JNwvzIS29guxy1Ae9mUuStIBgaetFsgsj8CDp
# G6gBOvZKIn4WgPgnGGNKm/n5426jkTFARkA2qSfuuf0/QQcCGvgEc9CUqd8C+kF4
# wG/VJLPG80W3hkTk60PTMao8F5N0A9cRSQpL7mPCGc6IdWRenVgEmNJ+0bq1kFdb
# dp8Lj9a+XciVZJpHVeguB+WQ8yzzkyb5okmDQBTEtTGCAXYwggFyAgEBMFYwSDET
# MBEGCgmSJomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixkARkWCmt1cnRzYWxtb24x
# FTATBgNVBAMTDEtTRyBTdWJDQSAwMQIKRJHmZwAAAAAg7TAJBgUrDgMCGgUAoHgw
# GAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQx
# FgQUFHixuoHcMJQKHPCrl6INa6Z/7mQwDQYJKoZIhvcNAQEBBQAEgYBwywdpOvP3
# uNmMSPkv4z+zSLVbHqRSRORhn3JmvOEGoVuXIIu2rF/Dy4PUz6yqvv/CaaFqOsKN
# Wm/Exf9uQEhbwtGrQQJu+YIuw6qL43vXmyPkQl11ebQYfRkUled+QvIN9pHZcM41
# QaC5H/VXq7H/CJqK3bYF4xvT3pKvZPB6Hg==
# SIG # End signature block
