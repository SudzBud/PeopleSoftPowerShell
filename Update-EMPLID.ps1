$updateEmpIDFile = "C:\PeopleSoftPowerShell\HRRPTIN\HRAD_20160111_01.csv"
$updateUsers = $(Import-Csv $updateEmpIDFile -Delimiter ";") | Select-Object LAST_NAME,FIRST_NAME,EMPLID
$psdata = foreach ($updateUser in $updateUsers){
  [string]$Lname = $updateUser.LAST_NAME
  [string]$Gname = $updateUser.FIRST_NAME
  [string]$PSID = $updateUser.EMPLID
  $cmdGet = @"
  Get-aduser -properties extensionattribute2 -filter {(surname -eq "$Lname")-and (givenname -eq "$Gname")}
"@

  $sb = [scriptblock]::create($cmdGet)

  $currentADUser = Invoke-Command $sb
  $SAMID = $currentADUser.SamAccountName
  $ADID =$currentADUser.extensionattribute2
  
  "Current EmplID for Surname:$Lname SAM:$SAMID is $ADID and will be changed to $PSID"
  
  $cmdSet = @"
  Set-ADUser $SAMID -Credential `$AdminCred -clear extensionattribute2
  Set-ADUser $SAMID -Credential `$AdminCred -add @{extensionattribute2 = `"$PSID`"}
"@
 	$sbSet = [scriptblock]::create($cmdSet)
  
  $sbSet
}
#$psdata
