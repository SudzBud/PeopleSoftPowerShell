
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
	if ($displayName -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -displayName:`"$displayName`" -Credential `$AdminCred`n"}
	if ($givenname -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -givenname:`"$givenname`" -Credential `$AdminCred`n"}
	if ($surName -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -surname:`"$surName`" -Credential `$AdminCred`n"}
	if ($mobile -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -mobile:`"$mobile`" -Credential `$AdminCred`n"}
	if ($FacsimileTelephoneNumber -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -fax:`"$FacsimileTelephoneNumber`" -Credential `$AdminCred`n"}
	if ($Division -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Division:`"$Division`" -Credential `$AdminCred`n"}
	if ($Department -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Department:`"$Department`" -Credential `$AdminCred`n"}
	if ($Office -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Office:`"$Office`" -Credential `$AdminCred`n"}
	if ($title -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -title:`"$title`" -Credential `$AdminCred`n"}
	if ($manager -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -manager:`"$manager`" -Credential `$AdminCred`n"}
	if ($Company -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Company:`"$Company`" -Credential `$AdminCred`n"}
	if ($streetAddress -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -streetAddress:`"$streetAddress`" -Credential `$AdminCred`n"}
	if ($city -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -city:`"$city`" -Credential `$AdminCred`n"}
	if ($state -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -state:`"$state`" -Credential `$AdminCred`n"}
	if ($postalcode -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -postalcode:`"$postalcode`" -Credential `$AdminCred`n"}
	if ($Country -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Country:`"$Country`" -Credential `$AdminCred`n"}
	if ($telephonenumber -ne ""){$primaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -officePhone:`"$telephonenumber`" -Credential `$AdminCred`n"}

	#Create Secondary Attributes Command
	if ($personalTitle -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{personaltitle = `"$personalTitle`"}`n"}
	if ($middlename -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{middlename = `"$middlename`"}`n"}
	if ($msExchAssistantName -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{msexchassistantname = `"$msExchAssistantName`"}`n"}
	if ($generationQualifier -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{generationqualifier = `"$generationQualifier`"}`n"}
	if ($extensionAttribute1 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute1 = `"$extensionAttribute1`"}`n"}
	if ($extensionAttribute3 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute3 = `"$extensionAttribute3`"}`n"}
	if ($extensionAttribute4 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute4 = `"$extensionAttribute4`"}`n"}
	if ($extensionAttribute5 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute5 = `"$extensionAttribute5`"}`n"}
	if ($extensionAttribute6 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute6 = `"$extensionAttribute6`"}`n"}
	if ($extensionAttribute9 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute9 = `"$extensionAttribute9`"}`n"}
	if ($extensionAttribute12 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute12 = `"$extensionAttribute12`"}`n"}
	if ($extensionAttribute13 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute13 = `"$extensionAttribute13`"}`n"}
	if ($extensionAttribute14 -ne "") {$secondaryAttributeCMD += "`$userObject.SamAccountName | Set-ADUser -Credential `$AdminCred -add @{extensionattribute14 = `"$extensionAttribute14`"}`n"}

	#Get Attributes to be changed for logging
	if ($action -ne "Create"){
    $aduserobject = Get-ADUser -filter "extensionAttribute2 -eq $extensionAttribute2" -Properties $adproperties
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
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute1 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute3 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute4 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute5 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute6 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute9 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute12 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute13 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear extensionattribute14 -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear personalTitle -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear middleName -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear telephonenumber -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear mobile -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear FacsimileTelephoneNumber -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear Division -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear Department -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear PhysicalDeliveryOfficeName -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear title -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear manager -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear msExchAssistantName -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear Company -Credential `$AdminCred
`$userObject.SamAccountName | Set-ADUser -clear generationQualifier -Credential `$AdminCred

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
