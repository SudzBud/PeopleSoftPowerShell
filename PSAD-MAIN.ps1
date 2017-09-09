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
'city','state','postalcode','officephone','personaltitle','middlename','msexchassistantname','generationqualifier','mail','extensionattribute1',`
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
$HRFilenameEU = "HRInfo-EU-" + $ADHRFilename
$HRExpFileEU = Join-Path $ADHRdirectory $HRFilenameEU 
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
$HRFilenameNA = "HRInfo-NA-" + $ADHRFilename
$HRExpFileNA = Join-Path $ADHRdirectory $HRFilenameNA 
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
    $combineName = $($adFMTuser.givenname + "." + $adFMTuser.surname).ToLower()
		$asciiName = Remove-Diacritics -string $combineName
		$suggestedAlias = Remove-SpecialChars $asciiName

    if($importuser.EMAIL_ADDR){
      $importedEmailAddress = $($importuser.EMAIL_ADDR).ToLower()
      $importedEmailAlias = $($($importedEmailAddress).Replace('@kurtsalmon.com',''))
		  if (($importedEmailAlias -ne $suggestedAlias) -and ($adFMTuser.I_ROW_FLAG -eq "C")){
        $suggestedAlias = $importedEmailAlias
			  $flag = $true
			  $flagReason += "###Person has suggested Email Address different from SuggestedAlias. Verify validity.###`n"
		  }
      if(($importedEmailAlias -ne $combineName) -and ($adFMTuser.I_ROW_FLAG -eq "C")){
        $flag = $true
			  $flagReason += "###Person has suggested Email Address different from First.Last. Possible diacritics or special characters. Verify validity.###`n"
      }
    }else{
		  if (($combineName -ne $suggestedAlias) -and ($adFMTuser.I_ROW_FLAG -eq "C")){
			  $flag = $true
			  $flagReason += "###Person's name contains diacritics or special characters. Login name may need to be adjusted for New Account.###`n"
		  }
    }

		$adFMTuser | Add-Member NoteProperty -Name suggestedAlias $suggestedAlias
		$adFMTuser | Add-Member NoteProperty -Name GenerationQualifier $importuser.NAME_SUFFIX
		$adFMTuser | Add-Member NoteProperty -Name PersonalTitle $importuser.NAME_PREFIX
		$adFMTuser | Add-Member NoteProperty -Name displayName $(if ($importuser.PREF_FIRST_NAME){
				$($importuser.LAST_NAME + ", " + $importuser.PREF_FIRST_NAME)}else{
					$($importuser.LAST_NAME + ", " + $importuser.FIRST_NAME)
				})
		[int]$PSID = $adFMTuser.EMPLID
		if (Get-Aduser -filter "ExtensionAttribute2 -eq $PSID"){
			$ADUser = $(Get-Aduser -filter "ExtensionAttribute2 -eq $PSID" -Properties $adproperties)
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
			$ADUser = get-aduser -Filter 'samaccountname -eq "$testname"' -Properties $adproperties
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
		$adFMTuser | Add-Member NoteProperty -Name Title $importuser.DESCR_JOBCODE
		$S_ID = $importuser.SUPERVISOR_ID
		if($S_ID){
			$manager = $(Get-ADUser -filter "extensionattribute2 -eq $S_ID")
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
		$adFMTcreateEU | Add-Member NoteProperty -Name Password $(New-Password)
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
	$createNA = foreach ($adFMTcreateNA in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "C") -and (($_.BUSINESS_UNIT -eq "USA") -or ($_.BUSINESS_UNIT -eq "CHN") -or ($_.BUSINESS_UNIT -eq "JPN") -or ($_.BUSINESS_UNIT -eq "GFS"))})){
		$adFMTcreateNA | Add-Member NoteProperty -Name Password $(New-Password)
		$adFMTcreateNA | Add-Member NoteProperty -Name ScriptBlock $(Set-ksPSAdUser $adFMTcreateNA)
		$adFMTcreateNA
		}
	$modifyNA = foreach ($adFMTmodifyNA in $($adFormatUsers | Where-Object {($_.I_ROW_FLAG -eq "M") -and (($_.BUSINESS_UNIT -eq "USA") -or ($_.BUSINESS_UNIT -eq "CHN") -or ($_.BUSINESS_UNIT -eq "JPN") -or ($_.BUSINESS_UNIT -eq "GFS"))})){
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
  $newhireOutHRdataEU = $createEU | Select-Object @{name="LoginID";expression={$_.suggestedAlias}},office,title,password
  	if ($newhireOutPSdataEU){
		$newhireOutPSdataEU | Export-Csv $HelpDeskFileEU -NoTypeInformation -Encoding UTF8
    $newhireOutHRdataEU | Export-Csv $HRExpFileEU -NoTypeInformation -Encoding UTF8
	}
#ENDREGION Export-CreationsScript EU

#REGION Export-CreationsScripts NA
	$newhireSBsNA = $($createNA | select scriptblock -ExpandProperty scriptblock)
	if ($newhireSBsNA){
		$newhireSBsNA | out-file $ScriptFileCNA -Width:600
	}
	$newhireOutPSdataNA = $createNA | Select-Object -Property * -ExcludeProperty scriptblock
  $newhireOutHRdataNA = $createNA | Select-Object @{name="LoginID";expression={$_.suggestedAlias}},office,title,password
	if ($newhireOutPSdataNA){
		$newhireOutPSdataNA | Export-Csv $HelpDeskFileNA -NoTypeInformation -Encoding UTF8
	  $newhireOutHRdataNA | Export-Csv $HRExpFileNA -NoTypeInformation -Encoding UTF8
    
  }
#ENDREGION Export-CreationsScript NA

#REGION Set-PS_ADHR_newhire_Data
	if ($newhireOutPSdataEU){
		$newhireOutPSdataALL = $newhireOutPSdataEU | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties SAMAccountName).SAMAccountName} 
		}
	}
	if (($newhireOutPSdataNA) -and ($newhireOutPSdataEU)){
		$newhireOutPSdataALL += $newhireOutPSdataNA | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties SAMAccountName).SAMAccountName} 
		}
	}else{$newhireOutPSdataALL = $newhireOutPSdataNA | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $_.EMPLID; $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties SAMAccountName).SAMAccountName} 
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

Set-Location "$(&$ScriptDir)"

#ENDREGION MAIN

<<<<<<< HEAD
Set-Location ..
=======
# SIG # Begin signature block
# MIIPAAYJKoZIhvcNAQcCoIIO8TCCDu0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/5+2zzXrROA1oq7hqj0n2TjE
# B3ygggxzMIIGETCCA/mgAwIBAgIKYTLgOwAAAAAAAjANBgkqhkiG9w0BAQUFADBH
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUA27J
# ioiVVcvSjedgwmh+TcXTimgwDQYJKoZIhvcNAQEBBQAEggEAdiJUMOhV9d5w6KkB
# 9464ZZ/dZnaAhSyHJ14OV9NAVOZ/scvu5z+PpIEB4I6DzhVIXSuxTLxzTjX3e3oT
# O7hNXHjXZqM6LoRdUsbjzNY5UHvghCuWBYNkDt+SpctjiPfuR8hokYRgsshDSV2c
# 5mJFo4ydSQcZQMFFL91Saiu/XbFcGOLCbKa81vwyt5yZFrFkTmE28R15x68J4qy2
# Ypmr1oRo2ASRBjJct1JYjwOIPcVlcP7c085aYlMPYHArGsQOq75ZgxG4R1Zd8oUj
# oVUJOuuwx++azXdscQ71tne/F76PIgr1RQfYPWYupaKuT6WWF82d7kgPfIHjoGra
# clWTJg==
# SIG # End signature block
>>>>>>> refs/remotes/origin/Development
