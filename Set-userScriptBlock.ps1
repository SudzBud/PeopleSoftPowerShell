
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
		$CreateUserCMD += "New-ADUser -Name `"$displayName`" -SAMAccountName `"$suggestedAlias`" -UserPrincipalName `"$userPrincipalName`" -AccountPassword `$AccountPassword -Enabled `$True -Path `"$OUpath`" -Credential `$AdminCred -OtherAttributes @{extensionattribute2 = `"$extensionAttribute2`"}`n"
		$CreateUserCMD += "do {sleep 3} until (get-aduser `"$suggestedAlias`")`n"
    $CreateUserCMD += "Enable-Mailbox `"$suggestedAlias`" -Database `"$MBXdatabase`"`n"
		$CreateUserCMD += "Set-Mailbox `"$suggestedAlias`" -scljunkenabled:`$true -scljunkthreshold:4"
		$getUserObjectCMD = "`$userObject = Get-ADUser `"$suggestedAlias`"`n"
	} else {$getUserObjectCMD = "`$userObject = Get-ADUser -filter {extensionAttribute2 -eq $extensionAttribute2}`n"}
	
	#Create Primary Attributes Command
	if ($displayName -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -displayName:`"$displayName`" -Credential `$AdminCred`n"}
	if ($givenname -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -givenname:`"$givenname`" -Credential `$AdminCred`n"}
	if ($surName -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -surname:`"$surName`" -Credential `$AdminCred`n"}
	if ($mobile -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -mobile:`"$mobile`" -Credential `$AdminCred`n"}
	if ($FacsimileTelephoneNumber -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -fax:`"$FacsimileTelephoneNumber`" -Credential `$AdminCred`n"}
	if ($Division -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Division:`"$Division`" -Credential `$AdminCred`n"}
	if ($Department -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Department:`"$Department`" -Credential `$AdminCred`n"}
	if ($Office -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -Office:`"$Office`" -Credential `$AdminCred`n"}
	if ($title -ne ""){$primaryAttributeCMD += "`$userObject | Set-ADUser -title:`"$title`" -Credential `$AdminCred`n"}
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
if ((($attributesToChange -ne $null) -and ($attributesToChange -ne "Country" )) -or ($action -eq "Create")){	
$cmd = @"

############################
#REGION $action $userName

###SCRIPTBLOCK to $action user object $userName###
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
`$userObject | Set-ADUser -clear title -Credential `$AdminCred
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
# MIIPAAYJKoZIhvcNAQcCoIIO8TCCDu0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4fKZbgvTimtsiaPG/6gK2GlR
# IFWgggxzMIIGETCCA/mgAwIBAgIKYTLgOwAAAAAAAjANBgkqhkiG9w0BAQUFADBH
# MRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYKa3VydHNhbG1v
# bjEUMBIGA1UEAxMLS1NHIFJvb3QgQ0EwHhcNMTExMTIzMTYwMDUwWhcNMTkxMTIz
# MTYxMDUwWjBIMRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYK
# a3VydHNhbG1vbjEVMBMGA1UEAxMMS1NHIFN1YkNBIDAxMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAyoOJkRYs+kEhBmuV28nH70OjzaiPUk+5i6EK4y7i
# cijMFhJ81w14/piKHEaCAGSJ8rSWZ+QLTKMVNSIkyhOfRsQP0NYASLmdUb+wVU+Y
# U3hInPBKvV+/nJOLpBS3U88Rp0td/CNh02kaVuWTGevPsFWgvWRh776Ip7srKhI3
# HuKnikIH/7Z2m/oOX1cSZUgpyoyhW3l6/8IIvLqvudYt8W9NPOxd+rGaCmyrFAW3
# RAfCRKcBmDBQXWUw48A6dGLzTBLvosgUgVNLYdb8bEpsalx7Fnv9/1YHDnRlCN0w
# JUdzwjE58sbdktqcO282IlevA4a1BqWm/ESoCP08CAHaUQIDAQABo4IB/DCCAfgw
# EAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFNmoHjMSBBK786LvavPoHT2HFEnC
# MBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMB
# Af8EBTADAQH/MB8GA1UdIwQYMBaAFBJEeBf8vcRqfV3w7Z8dUpOF3QTwMIIBCwYD
# VR0fBIIBAjCB/zCB/KCB+aCB9oY5aHR0cDovL2tzZ3BraS5rdXJ0c2FsbW9uLmNv
# bS9DZXJ0RGF0YS9LU0clMjBSb290JTIwQ0EuY3JshoG4bGRhcDovLy9DTj1LU0cl
# MjBSb290JTIwQ0EsQ049bmFyb290LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBT
# ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWt1cnRzYWxt
# b24sREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RD
# bGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDBcBggrBgEFBQcBAQRQME4wTAYIKwYB
# BQUHMAKGQGh0dHA6Ly9rc2dwa2kua3VydHNhbG1vbi5jb20vQ2VydERhdGEvbmFy
# b290X0tTRyUyMFJvb3QlMjBDQS5jcnQwDQYJKoZIhvcNAQEFBQADggIBAGx6VzG3
# UUMcAoH2IvPr5rGX6V8UtqUxy+23lbW9s/5jnzmIV+ZfaKPmDLuknZKL4EUXkFw/
# AoqK6Zw4P1QzSBynZ3eB4oG6t0ig9ZQ55xPI8lqqwSEG3tghYrRwqEEIIhK2WDWp
# 4rNF0yYv3VTfdFJJjf2yVEnKcv7rtekAtF2pM0iX3yz1/P34rF1LiUPiC/xXzump
# ad/ywcFbiQJfXfOodRoggohOZgpyGTSNO34DeVNQsBneObeOTyOLdOLdvB6cL+fi
# xa/1Y1yDi1jEbvUtkAALPDkzKIybY/J8SLo0F/92fU86DZxLhuN0+6UDJw1aAIXW
# wejjPmv6BflvyRyH+wcDk5bXTi3l0enDJLKodJ473Bjp8C5yRa3jhMLFITLTX9gm
# FH8K5KonZguRrgm3QQcPSXWkwNz4J1DFjUJlqlf9uFGgvaxvyNDw+j8cRaH8X1vP
# rxdrgwXTuaz6sXgdcU8Cf0k3C/MhLb2C7HLUB72ZS5K0gGBp60WyCyPwIOkbqAE6
# 9koifhaA+CcYY0qb+fnjbqORMUBGQDapJ+65/T9BBwIa+ARz0JSp3wL6QXjAb9Uk
# s8bzRbeGROTrQ9MxqjwXk3QD1xFJCkvuY8IZzoh1ZF6dWASY0n7RurWQV1t2nwuP
# 1r5dyJVkmkdV6C4H5ZDzLPOTJvmiSYNAFMS1MIIGWjCCBUKgAwIBAgIKQwIxRQAA
# AAApEDANBgkqhkiG9w0BAQUFADBIMRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYK
# CZImiZPyLGQBGRYKa3VydHNhbG1vbjEVMBMGA1UEAxMMS1NHIFN1YkNBIDAxMB4X
# DTE0MDcwODEzMzMyMVoXDTE3MDcwNzEzMzMyMVowfDETMBEGCgmSJomT8ixkARkW
# A2NvbTEaMBgGCgmSJomT8ixkARkWCmt1cnRzYWxtb24xEjAQBgNVBAsTCUVtcGxv
# eWVlczELMAkGA1UECxMCTkExEjAQBgNVBAsTCUNvcnBvcmF0ZTEUMBIGA1UEAxML
# UG9ydGVyLCBCdWQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/bQne
# QUFxpsJA2gzEgB/mwYOWK16YArbVc69/CVKOo8JpC+7ptZ9YFxMhalfH4BmNc54R
# VQhouDXgnG1rnnxVzzo/0BGEhJ/G7ot5Ku6rA07MOhEepWuuB+WAqXxjzKu+5z7K
# OkgPcZq4D6SUUVcgzPoqXATMUd4CyjZWD8BBbPszs2Ra9d4FYqQegao9gcgUlpOb
# +7qZPP0a/BtDdnSMbDFB4AFk9rEAAhwbv9hRp4MXCSFPhtC4jVxwoJNTP6PqeiQG
# 8HCPLSMT7pj+uS5CS72N4QPo4G6Q73Q9euT5D3AlGWbgXonYz9D4jBvgBOJV9YsS
# Inf+Sbdiffarlq1jAgMBAAGjggMQMIIDDDA+BgkrBgEEAYI3FQcEMTAvBicrBgEE
# AYI3FQiHpu9yhd+TaYXxhSuHzO8Ig/uqNoEWh6fiL4Wp3igCAWQCAQIwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMwCwYDVR0PBAQDAgeAMBsGCSsGAQQBgjcVCgQOMAwwCgYI
# KwYBBQUHAwMwHQYDVR0OBBYEFPpiZ4uUBkOeDnCuPdeBqDinKIi3MB8GA1UdIwQY
# MBaAFNmoHjMSBBK786LvavPoHT2HFEnCMIIBTwYDVR0fBIIBRjCCAUIwggE+oIIB
# OqCCATaGgbpsZGFwOi8vL0NOPUtTRyUyMFN1YkNBJTIwMDEsQ049bmFzdWJjYSxD
# Tj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049
# Q29uZmlndXJhdGlvbixEQz1rdXJ0c2FsbW9uLERDPWNvbT9jZXJ0aWZpY2F0ZVJl
# dm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9p
# bnSGPWh0dHA6Ly9uYXN1YmNhLmt1cnRzYWxtb24uY29tL0NlcnRFbnJvbGwvS1NH
# JTIwU3ViQ0ElMjAwMS5jcmyGOGh0dHA6Ly9uYXN1YmNhLmt1cnRzYWxtb24uY29t
# L0NSTC9LU0clMjBTdWJDQSUyMDAxLy8uY3JsMIHFBggrBgEFBQcBAQSBuDCBtTCB
# sgYIKwYBBQUHMAKGgaVsZGFwOi8vL0NOPUtTRyUyMFN1YkNBJTIwMDEsQ049QUlB
# LENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZp
# Z3VyYXRpb24sREM9a3VydHNhbG1vbixEQz1jb20/Y0FDZXJ0aWZpY2F0ZT9iYXNl
# P29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwMAYDVR0RBCkwJ6Al
# BgorBgEEAYI3FAIDoBcMFVJCUE9SVEBrdXJ0c2FsbW9uLmNvbTANBgkqhkiG9w0B
# AQUFAAOCAQEAAy36ZQzSeWz4Hbi0HHrNjLs1gew3ycHLNlzlC8kk90TIUhE8W6wX
# uucG2BGKBv258NcuOpMIfLtvsFovGNbgVSE6WuzFdOfl/9wpD80KegbUdbLBM52Q
# Bet028Vi3OmOug2sj0BYWSqV9cjkon5ol/ybeo8a1CtQ0zbzI+W7qMjMdFoyWYX3
# Xv0bduXsv97cpzCBPExi0CCYy79R/eQzZBVwOl2yr0PNDwBFKAvzpGWQQLoEDfFz
# lxl/lYWgfW2IboTvCaWTlWJsT6I2nLAfw9OtMgjRYJmR/CkJRgDUuJS/ubReILm+
# rPGYbjV9fo/ja87R06RG37lxmYR2+8VJWTGCAfcwggHzAgEBMFYwSDETMBEGCgmS
# JomT8ixkARkWA2NvbTEaMBgGCgmSJomT8ixkARkWCmt1cnRzYWxtb24xFTATBgNV
# BAMTDEtTRyBTdWJDQSAwMQIKQwIxRQAAAAApEDAJBgUrDgMCGgUAoHgwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUBpv3
# bggrPX94M9R8XbiJDeIZJkgwDQYJKoZIhvcNAQEBBQAEggEAB714UJxkvlqpdBjf
# G/Jh4OLpeGiGp7H79GvqwLxRRiHhFm2Ik+mWVHIzF7o6bNbkYlBx4IBszXHTRWB2
# Pk5nibjXG/J292OOLJUfzzqrUPhBfTOSPm+wHu0Q47uJSPiLIi3BzCRIw1bFqnjz
# vaXqpDYKbVFL2MOmLgGl1YOvk8xtlsWuLKujjaCOqZEPkweLhFNtwtk84b3m+KiA
# E7V3mX42+YbicEueSl5oqcOylQC0hF9x/+e8BOGYEpmrsdRPLSyoCprR54uUu3ex
# qMkGUdL2kqLCBCVkW2t/jVc5KTmWo4dBfol/aA5SJyLX86rTMjN+JBzuuFpTdyDc
# +eKLdQ==
# SIG # End signature block
