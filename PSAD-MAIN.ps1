####################REQUIRES AD and EXCHANGE CMDLETS and Rights to mailboxes and AD Objects#############################

#REGION Initialize
$ScriptDir = { Split-Path $MyInvocation.ScriptName –Parent }
."$(&$ScriptDir)\PS-AD-Functions.ps1"
."$(&$ScriptDir)\Set-userScriptBlock.ps1"
if(!(Test-Path "c:\PeopleSoftPowershell\outScripts" -PathType Container)){New-Item "c:\PeopleSoftPowershell\outScripts"  -Type Directory}
$OutScriptsDir = "c:\PeopleSoftPowershell\outScripts"
if(!(Test-Path "c:\PeopleSoftPowershell\HRRPTIN" -PathType Container)){New-Item "c:\PeopleSoftPowershell\HRRPTIN"  -Type Directory}
$HRADdirectory = "c:\PeopleSoftPowershell\HRRPTIN"
Set-Location $HRADdirectory
$incomingfiles = Get-ChildItem $HRADdirectory -Filter *.csv | Where-Object {$_.name -like "*$(Get-Date -Format yyyMMdd)*"}
if(!(Test-Path "c:\PeopleSoftPowershell\HRRPTOUT" -PathType Container)){New-Item "c:\PeopleSoftPowershell\HRRPTOUT"  -Type Directory}
$ADHRdirectory = "c:\PeopleSoftPowershell\HRRPTOUT"
$ADHRFilePrefix = "ADHR_"
$FileDatePart = $(Get-Date -Format yyyyMMdd).tostring()
$ADHRFileExt = ".csv"
$ScriptFileExt = ".ps1"
$ADHRFileBaseName = $ADHRFilePrefix + $FileDatePart
$ADHRGetFile = Get-ChildItem -path $ADHRdirectory -name $ADHRFileBaseName*
[int]$ADHRFileIncrement = if (!($ADHRGetFile)){1} else {if ($ADHRGetFile.count -eq $null){2} else {$ADHRGetfile.count+1}}
$ADHRFileName = $ADHRFileBaseName + "_" + $ADHRFileIncrement + $ADHRfileExt
$ADHRFile = Join-Path $ADHRdirectory $ADHRFilename 
$offices = Import-Csv "$(&$ScriptDir)\officeAddresses.csv"
$officeTable = @{}
	foreach ($office in $offices){$officeTable.($office.office) = $office}
$adproperties = 'displayname','mobile','facsimileTelephoneNumber','division','department','office','title','manager','company','streetaddress',`
'city','state','postalcode','officephone','personaltitle','middlename','msexchassistantname','generationqualifier','extensionattribute1',`
'extensionattribute2','extensionattribute3','extensionattribute4','extensionattribute5','extensionattribute6','extensionattribute7',`
'extensionattribute8','extensionattribute9','extensionattribute10','extensionattribute11','extensionattribute12','extensionattribute13',`
'extensionattribute14','extensionattribute15'

#REGION EU Script File Initialize
$ScriptFilePrefixCEU = "ADHR-EU-Creations-Script_"
$ScriptFilePrefixMEU = "ADHR-EU-Modifications-Script_"
$ScriptFilePrefixSEU = "ADHR-EU-Departs-Script_"
$ScriptFileBaseNameCEU = $ScriptFilePrefixCEU + $FileDatePart
$ScriptFileBaseNameMEU = $ScriptFilePrefixMEU + $FileDatePart
$ScriptFileBaseNameSEU = $ScriptFilePrefixSEU + $FileDatePart
$ScriptGetFileCEU = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameCEU*
[int]$ScriptFileIncrementCEU = if (!($ScriptGetFileCEU)){1} else {if ($ScriptGetFileCEU.count -eq $null){2} else {$ScriptGetfileCEU.count+1}}
$ScriptGetFileMEU = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameMEU*
[int]$ScriptFileIncrementMEU = if (!($ScriptGetFileMEU)){1} else {if ($ScriptGetFileMEU.count -eq $null){2} else {$ScriptGetfileMEU.count+1}}
$ScriptGetFileSEU = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameSEU*
[int]$ScriptFileIncrementSEU = if (!($ScriptGetFileSEU)){1} else {if ($ScriptGetFileSEU.count -eq $null){2} else {$ScriptGetfileSEU.count+1}}
$ScriptFileNameCEU = $ScriptFileBaseNameCEU + "_" + $ScriptFileIncrementCEU + $ScriptFileExt
$ScriptFileNameMEU = $ScriptFileBaseNameMEU + "_" + $ScriptFileIncrementMEU + $ScriptFileExt
$ScriptFileNameSEU = $ScriptFileBaseNameSEU + "_" + $ScriptFileIncrementSEU + $ScriptFileExt
$HelpDeskFilenameEU = "HelpDeskInfo-EU-" + $ADHRFilename
$HelpDeskFileEU = Join-Path $ADHRdirectory $HelpDeskFilenameEU 
$departsFilenameEU = "DepartsInfo-EU-" + $ADHRFilename
$departsFileEU = Join-Path $ADHRdirectory $departsFilenameEU
$ScriptFileCEU = Join-Path $OutScriptsDir $ScriptFilenameCEU
$ScriptFileMEU = Join-Path $OutScriptsDir $ScriptFilenameMEU
$ScriptFileSEU = Join-Path $OutScriptsDir $ScriptFilenameSEU
#ENDREGION EU Script File Initialize

#REGION NA Script File Initialize
$ScriptFilePrefixCNA = "ADHR-NA-Creations-Script_"
$ScriptFilePrefixMNA = "ADHR-NA-Modifications-Script_"
$ScriptFilePrefixSNA = "ADHR-NA-Departs-Script_"
$ScriptFileBaseNameCNA = $ScriptFilePrefixCNA + $FileDatePart
$ScriptFileBaseNameMNA = $ScriptFilePrefixMNA + $FileDatePart
$ScriptFileBaseNameSNA = $ScriptFilePrefixSNA + $FileDatePart
$ScriptGetFileCNA = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameCNA*
[int]$ScriptFileIncrementCNA = if (!($ScriptGetFileCNA)){1} else {if ($ScriptGetFileCNA.count -eq $null){2} else {$ScriptGetfileCNA.count+1}}
$ScriptGetFileMNA = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameMNA*
[int]$ScriptFileIncrementMNA = if (!($ScriptGetFileMNA)){1} else {if ($ScriptGetFileMNA.count -eq $null){2} else {$ScriptGetfileMNA.count+1}}
$ScriptGetFileSNA = Get-ChildItem -path $OutScriptsDir -name $ScriptFileBaseNameSNA*
[int]$ScriptFileIncrementSNA = if (!($ScriptGetFileSNA)){1} else {if ($ScriptGetFileSNA.count -eq $null){2} else {$ScriptGetfileSNA.count+1}}
$ScriptFileNameCNA = $ScriptFileBaseNameCNA + "_" + $ScriptFileIncrementCNA + $ScriptFileExt
$ScriptFileNameMNA = $ScriptFileBaseNameMNA + "_" + $ScriptFileIncrementMNA + $ScriptFileExt
$ScriptFileNameSNA = $ScriptFileBaseNameSNA + "_" + $ScriptFileIncrementSNA + $ScriptFileExt
$HelpDeskFilenameNA = "HelpDeskInfo-NA-" + $ADHRFilename
$HelpDeskFileNA = Join-Path $ADHRdirectory $HelpDeskFilenameNA 
$departsFilenameNA = "DepartsInfo-NA-" + $ADHRFilename
$departsFileNA = Join-Path $ADHRdirectory $departsFilenameNA
$ScriptFileCNA = Join-Path $OutScriptsDir $ScriptFilenameCNA
$ScriptFileMNA = Join-Path $OutScriptsDir $ScriptFilenameMNA
$ScriptFileSNA = Join-Path $OutScriptsDir $ScriptFilenameSNA
#ENDREGION NA Script File Initialize

#ENDREGION Initialize

if(!($incomingfiles)){Break}

#REGION MAIN
#TODO conversion to UTF8 cannot output to same directory as IN if run in \\ksafile\cci\!
	$importfiles = foreach ($infile in $incomingfiles){
		$outfile = $(Join-Path $infile.DirectoryName $($infile.BaseName + "-utf8" + $infile.Extension))
		Get-Content $infile | Set-Content $outfile -Encoding utf8
		$(Get-Item $outfile)
	}
	
	[array]$importdata = foreach ($importfile in $importfiles){
		[array]$importfiledata = Import-Csv $importfile -Delimiter ";"
		$count = $importfiledata.length
		for ($i = 0 ; $i -lt $count ; $i++) {
			$importfiledata[$i] | select *,@{
				name="InFile";expression={$importfile}
			},@{
				name="RecordNum";expression={$i + 1}
			}
		}
	}

#REGION UserAttributeProcessing
	$adFormatUsers = foreach ($importuser in $importdata){
		$adFMTuser = $importuser | select I_ROW_FLAG,EMPLID,InFile,RecordNum,EFFDT,CREATED_DTTM,BUSINESS_UNIT
		if (($importuser.PREF_FIRST_NAME) -and ($importuser.PREF_FIRST_NAME -ne $importuser.FIRST_NAME)){
			$flag = $true
			$flagReason +="###User has Preferred First Name, verify LOGIN and EMAIL.###`n"
		}
		$adFMTuser | Add-Member NoteProperty -Name surname $importuser.LAST_NAME
		$adFMTuser | Add-Member NoteProperty -Name givenname $(if ($importuser.PREF_FIRST_NAME){
				$($importuser.PREF_FIRST_NAME)}else{$($importuser.FIRST_NAME)
				})
		$adFMTuser | Add-Member NoteProperty -Name middlename $importuser.MIDDLE_NAME
		$combineName = $($adFMTuser.givenname + "." + $adFMTuser.surname).tolower()
		$asciiName = Remove-Diacritics -string $combineName
		$suggestedAlias = Remove-SpecialChars $asciiName
		if (($combineName -ne $suggestedAlias) -and ($adFMTuser.I_ROW_FLAG -eq "C")){
			$flag = $true
			$flagReason += "###Person's name contains diacritics or special characters. Login name may need to be adjusted for New Account.###`n"
		}
		$adFMTuser | Add-Member NoteProperty -Name suggestedAlias $suggestedAlias
		$adFMTuser | Add-Member NoteProperty -Name GenerationQualifier $importuser.NAME_SUFFIX
		$adFMTuser | Add-Member NoteProperty -Name PersonalTitle $importuser.NAME_PREFIX
		$adFMTuser | Add-Member NoteProperty -Name displayName $(if ($importuser.PREF_FIRST_NAME){
				$($importuser.LAST_NAME + ", " + $importuser.PREF_FIRST_NAME)}else{
					$($importuser.LAST_NAME + ", " + $importuser.FIRST_NAME)
				})
		[int]$PSID = $adFMTuser.EMPLID
		if (Get-Aduser -filter {ExtensionAttribute2 -eq $PSID}){
			$ADUser = $(Get-Aduser -filter {ExtensionAttribute2 -eq $PSID} -Properties $adproperties)
			if ($adFMTuser.I_ROW_FLAG -eq "M") {
				if (($adFMTuser.givenname -ne $ADUser.GivenName) -or ($adFMTuser.surname -ne $ADUser.surName) -or ($adFMTuser.displayName -ne $ADUser.DisplayName)){
					$flag = $true
					$flagReason +="###NAME CHANGE will occur!###`n"
				}	
			}
			if ($ADUser.samaccountname){
				$adFMTuser | Add-Member NoteProperty -Name LOGIN $ADUser.samaccountname
				$adFMTuser | Add-Member NoteProperty -Name AccountExist "User with SAMAccountName $($adFMTuser.LOGIN) already exists. Matched EMPLID: $PSID"
			} else {
				$flag = $true
				$flagReason += "###Matched EMPLID $PSID found, No SAMAccountName associated with Account.###`n"
			}
			if ($ADUser.mail){
				$adFMTuser | Add-Member NoteProperty -Name EMAIL $ADUser.mail
				$adFMTuser | Add-Member NoteProperty -Name MailExist "Mail Recipient with Address $($adFMTuser.EMAIL) already exists. Matched EMPLID: $PSID"
			} else{
				$flag = $true
				$flagReason += "###Matched EMPLID $PSID found, No Mailbox associated with Account.###`n"
			}
		} else {
			$testname = $adFMTuser.suggestedAlias
			$testmail = $testname + "@kurtsalmon.com"
			$ADUser = get-aduser -Filter {samaccountname -eq $testname} -Properties $adproperties
			$mailRecip = get-recipient -erroraction:silentlycontinue $testmail
			if ($ADUser){
				$flag = $true
				$ADid = $ADUser.ExtensionAttribute2
				$userExist = "User with SAMAccountName $testname already exists! UNMATCHED IDS: PSID:$PSID ADID:$ADid"
				$flagReason += "###Possible Account Conflict or Missing/Incorrect EMPLID. $userExist###`n"
				$adFMTuser | Add-Member NoteProperty -Name LOGIN $ADUser.samaccountname
			} else {
				$userExist = "SAMAccountName $testname not found."
			}
			if ($mailRecip){
				$flag = $true 
				$mailExist = "Mail Recipient with Address $testmail already exists! UNMATCHED IDS: PSID:$PSID ADID:$ADid"
				$flagReason += "###Possible Mail Recipient Conflict or Missing/Incorrect EMPLID. $mailExist###`n"
				$adFMTuser | Add-Member NoteProperty -Name EMAIL $ADUser.mail
			} else {
				$mailExist = "Mail Recipient not found."
			}
 			$adFMTuser | Add-Member NoteProperty -Name AccountExist $userExist
 			$adFMTuser | Add-Member NoteProperty -Name MailExist $mailExist
		}

		$adFMTuser | Add-Member NoteProperty -Name mail $importuser.EMAIL_ADDR
		$adFMTuser | Add-Member NoteProperty -Name telephonenumber $importuser.I_TEL_PRO
		$adFMTuser | Add-Member NoteProperty -Name mobile $importuser.I_MOBIL_PRO
		$adFMTuser | Add-Member NoteProperty -Name FacsimileTelephoneNumber $importuser.I_FAX_PRO
		$adFMTuser | Add-Member NoteProperty -Name Company $importuser.DESCR_COMPANY
		$adFMTuser | Add-Member NoteProperty -Name Division $importuser.DESCR_SEGMENT
		$adFMTuser | Add-Member NoteProperty -Name Department $importuser.DESCR_DEPTID
		$adFMTuser | Add-Member NoteProperty -Name Office $importuser.DESCR_LOCATION
		$adFMTuser | Add-Member NoteProperty -Name title $importuser.DESCR_JOBCODE
		$S_ID = $importuser.SUPERVISOR_ID
		if($S_ID){
			$manager = $(Get-ADUser -filter {extensionattribute2 -eq $S_ID})
			$adFMTuser | Add-Member NoteProperty -Name manager $manager
		}		
		$adFMTuser | Add-Member NoteProperty -Name msExchAssistantName $importuser.I_EMPLID_SECRET
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute1 $importuser.I_SEGMENT_ID
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute2 $importuser.EMPLID
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute3 $importuser.I_SERVICE_LINE_ID
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute4 $importuser.DEPTID
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute5 $importuser.LOCATION
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute6 $importuser.GRADE
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute9 $importuser.EMPL_CLASS
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute12 $importuser.CONTRACT_TYPE
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute13 $importuser.JOBCODE
		$adFMTuser | Add-Member NoteProperty -Name ExtensionAttribute14 $importuser.UNION_SENIORITY_DT
		$adFMTuser | Add-Member NoteProperty -Name streetAddress (
			$officeTable.($adFMTuser.office)).streetAddress
		$adFMTuser | Add-Member NoteProperty -Name city (
			$officeTable.($adFMTuser.office)).city
		$adFMTuser | Add-Member NoteProperty -Name state (
			$officeTable.($adFMTuser.office)).state
		$adFMTuser | Add-Member NoteProperty -Name postalcode (
			$officeTable.($adFMTuser.office)).postalcode
		$adFMTuser | Add-Member NoteProperty -Name Country (
			$officeTable.($adFMTuser.office)).Country
		$adFMTuser | Add-Member NoteProperty -Name officePhone (
			$officeTable.($adFMTuser.office)).officePhone
		$adFMTuser | Add-Member NoteProperty -Name OUpath $(Get-OUPath $adFMTuser)
		$adFMTuser | Add-Member NoteProperty -Name MBXdatabase $(Get-MBXdatabase $adFMTuser)
		if(($adFMTuser.I_ROW_FLAG -eq "C")-and(($adFMTuser.EMAIL)-or($adFMTuser.LOGIN))){
			$flag = $true
			$flagReason +="###User object marked for creation, but either conflict exists or Account already exists.###`n"
		}
		if ($flag){$adFMTuser | Add-Member NoteProperty -Name Warning $flagReason.trimend("`n")}
		$flag = $false
		$flagReason = $null
	$adFMTuser
	}
#ENDREGION UserAttributeProcessing

#REGION Segregate EU Actions
	$createEU = foreach ($adFMTcreateEU in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "C") -and (($_.BUSINESS_UNIT -eq "GBR") -or ($_.BUSINESS_UNIT -eq "DEU"))})){
		$adFMTcreateEU | Add-Member NoteProperty -Name PASSWORD $(New-Password)
		$adFMTcreateEU | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTcreateEU)
		$adFMTcreateEU
		}
	$modifyEU = foreach ($adFMTmodifyEU in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "M") -and (($_.BUSINESS_UNIT -eq "GBR") -or ($_.BUSINESS_UNIT -eq "DEU"))})){
		$adFMTmodifyEU | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTmodifyEU)
		$adFMTmodifyEU
		}
#	$departEU = foreach ($adFMTdepartEU in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "S") -and (($_.BUSINESS_UNIT -eq "GBR") -or ($_.BUSINESS_UNIT -eq "DEU"))})){
# 		$adFMTdepartEU | Add-Member NoteProperty -Name DepartureDate $($_.EFFDT)
# 		$adFMTdepartEU | Add-Member NoteProperty -Name AccountDeletionDate $($_.UNION_SENIORITY_DT)
# 		$adFMTdepartEU | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTdepartEU)
# 		$adFMTdepartEU
#		}
#ENDREGION Segregate EU Actions	

#REGION Segregate NA Actions
	$createNA = foreach ($adFMTcreateNA in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "C") -and (($_.BUSINESS_UNIT -eq "USA") -or ($_.BUSINESS_UNIT -eq "CHN") -or ($_.BUSINESS_UNIT -eq "JPN"))})){
		$adFMTcreateNA | Add-Member NoteProperty -Name PASSWORD $(New-Password)
		$adFMTcreateNA | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTcreateNA)
		$adFMTcreateNA
		}
	$modifyNA = foreach ($adFMTmodifyNA in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "M") -and (($_.BUSINESS_UNIT -eq "USA") -or ($_.BUSINESS_UNIT -eq "CHN") -or ($_.BUSINESS_UNIT -eq "JPN"))})){
		$adFMTmodifyNA | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTmodifyNA)
		$adFMTmodifyNA
		}
#	$departNA = foreach ($adFMTdepartNA in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "S") -and (($_.BUSINESS_UNIT -eq "USA") -or ($_.BUSINESS_UNIT -eq "CHN") -or ($_.BUSINESS_UNIT -eq "JPN"))})){
# 		$adFMTdepartNA | Add-Member NoteProperty -Name DepartureDate $($_.EFFDT)
# 		$adFMTdepartNA | Add-Member NoteProperty -Name AccountDeletionDate $($_.UNION_SENIORITY_DT)
# 		$adFMTdepartNA | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTdepartNA)
# 		$adFMTdepartNA
#		}
#ENDREGION Segregate NA Actions	

#REGION Export-CreationsScripts EU
	$newhireSBsEU = $($createEU | select scriptblock -ExpandProperty scriptblock)
	if ($newhireSBsEU){
		$newhireSBsEU | out-file $ScriptFileCEU -Width:600
	}
	$newhireOutPSdataEU = $createEU | Select-Object -Property * -ExcludeProperty scriptblock
	if ($newhireOutPSdataEU){
		$newhireOutPSdataEU | Export-Csv $HelpDeskFileEU -NoTypeInformation -Encoding UTF8
	}
#ENDREGION Export-CreationsScript EU

#REGION Export-CreationsScripts NA
	$newhireSBsNA = $($createNA | select scriptblock -ExpandProperty scriptblock)
	if ($newhireSBsNA){
		$newhireSBsNA | out-file $ScriptFileCNA -Width:600
	}
	$newhireOutPSdataNA = $createNA | Select-Object -Property * -ExcludeProperty scriptblock
	if ($newhireOutPSdataNA){
		$newhireOutPSdataNA | Export-Csv $HelpDeskFileNA -NoTypeInformation -Encoding UTF8
	}
#ENDREGION Export-CreationsScript NA

#REGION Set-PS_ADHR_newhire_Data
	if ($newhireOutPSdataEU){
		$newhireOutPSdataALL = $newhireOutPSdataEU | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties SAMAccountName).SAMAccountName} 
		}
	}
	if (($newhireOutPSdataNA) -and ($newhireOutPSdataEU)){
		$newhireOutPSdataALL += $newhireOutPSdataNA | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties SAMAccountName).SAMAccountName} 
		}
	}else{$newhireOutPSdataALL = $newhireOutPSdataNA | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties SAMAccountName).SAMAccountName} 
		}
	}
#ENDREGION Set-PS_ADHR_Newhire_Data

#REGION Export-ModificationsScript EU
	$modificationSBsEU = $($modifyEU | select scriptblock -ExpandProperty scriptblock) 
	if($modificationSBsEU){
		$modificationSBsEU | out-file $ScriptFileMEU -Width:600 
	}
#ENDREGION Export-ModificationsScript EU

#REGION Export-ModificationsScript NA
	$modificationSBsNA = $($modifyNA | select scriptblock -ExpandProperty scriptblock) 
	if($modificationSBsNA){
		$modificationSBsNA | out-file $ScriptFileMNA -Width:600 
	}
#ENDREGION Export-ModificationsScript NA

#REGION Export-DeparturesScript EU
# 	$departSBsEU = $($departEU | select scriptblock -ExpandProperty scriptblock) 
# 	$departSBsEU | out-file $ScriptFileSEU -Width:600
# 	$departOutPSdataEU = $departEU | Select-Object -Property * -ExcludeProperty scriptblock
# 	if ($departOutPSdataEU){
# 		$departOutPSdataEU | Export-Csv $departsFileEU -NoTypeInformation -Encoding UTF8
#ENDREGION Export-DeparturesScript EU

#REGION Export-DeparturesScript NA
# 	$departSBsNA = $($departNA | select scriptblock -ExpandProperty scriptblock) 
# 	$departSBsNA | out-file $ScriptFileSNA -Width:600
# 	$departOutPSdataNA = $departNA | Select-Object -Property * -ExcludeProperty scriptblock
# 	if ($departOutPSdataNA){
# 		$departOutPSdataNA | Export-Csv $departsFileNA -NoTypeInformation -Encoding UTF8
#ENDREGION Export-DeparturesScript NA

#REGION Set-PS_ADHR_Depart_Data
# 	if ($departOutPSdataEU){
# 		$departOutPSdataALL = $departOutPSdataEU | Select-Object I_ROW_FLAG,EMPLID,@{
# 		name="EMAIL";expression={" "}
# 		},@{
# 		name="LOGIN";expression={" "} 
# 		}
# 	}
# 	if ($departOutPSdataNA){
# 		$departOutPSdataALL += $departOutPSdataNA | Select-Object I_ROW_FLAG,EMPLID,@{
# 		name="EMAIL";expression={" "}
# 		},@{
# 		name="LOGIN";expression={" "} 
# 		}
# 	}
#ENDREGION Set-PS_ADHR_Depart_Data

#REGION Export-PS_ADHR_OUTFILE
# 	if ($newhireOutPSdataALL){
# 		$OutPSDataALL = $newhireOutPSdataALL
# 	}
# 	if ($departOutPSdataALL){
# 		$OutPSDataALL += $departOutPSdataALL
# 	}
# 	if ($OutPSdataALL){
# 		$OutPSdataALL | Export-Csv $ADHRFile -NoTypeInformation -Encoding UTF8 -Delimiter ";"
# 	}
#ENDREGION Export-PS_ADHR_OUTFILE

#ENDREGION MAIN

# SIG # Begin signature block
# MIINxQYJKoZIhvcNAQcCoIINtjCCDbICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+VGaOYQfinetFK6TMJs/0NxY
# 2j2gggu5MIIFoDCCBIigAwIBAgIKRJHmZwAAAAAg7TANBgkqhkiG9w0BAQUFADBI
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
# FgQUCj46yBoGlTmiJqJAD0RWfYPjco4wDQYJKoZIhvcNAQEBBQAEgYCiUjBxa1M+
# aKlzn9h8Rjq2ul9z5zd1SPFH+Lkmy08YHOT+zSjqfkqW55mV36ZEiUXIIOTcx8Xy
# /HMc1j/NtFchs8FG1vDPf+W/AdaoGBtxpE8ryU8XcrWS14BKlZUuFOz6cXxhtjHX
# TnAAXxGefA10dc4A9qbJ782ofktvymGR+w==
# SIG # End signature block
