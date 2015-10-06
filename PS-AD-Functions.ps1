
#REGION SubFunctions
$ScriptDir = { Split-Path $MyInvocation.ScriptName –Parent }
# $scriptDir = "C:\Development Workspace\Network Group - Development-Branch\PowerShell Scripts\KSG_PeopleSoft_AD_Project"

#REGION New-Password
	function New-Password(){ 
		param(
			[int] $genNum = 1,
			[int] $Length = 8,
			[int] $Lower = 2,
			[int] $Upper = 2,
			[int] $Numeric = 2
		)
	
		function shuffle ($a) {
			$c = $a.Clone() # make copy to avoid clobbering $a
			1..($c.Length - 1) | ForEach-Object {
				$i = Get-Random -Minimum $_ -Maximum $c.Length
				$c[$_-1],$c[$i] = $c[$i],$c[$_-1]
				$c[$_-1] # return newly-shuffled value
			}
			$c[-1] # last value
		}

		#REGION Get-PasswordChars
			function Get-PasswordChars($pwdLength,$countLower,$countUpper,$countNumeric,$countRand){
			$arrLower = $(97..122 | %{[char]$_})
			$arrUpper = $(65..90 | %{[char]$_})
			$arrNum = $(48..57 | %{[char]$_})
			$arrAll = $($arrLower + $arrUpper + $arrNum)
			
			[array]$pwdCharsLower = $(Get-Random -InputObject $arrLower -Count $countLower) 
			[array]$pwdCharsUpper = $(Get-Random -InputObject $arrUpper -Count $countUpper) 
			[array]$pwdCharsNum = $(Get-Random -InputObject $arrNum -Count $countNumeric)
			
				if ($countRand -gt 0) {
					$pwdCharsRandom = $(Get-Random -InputObject $arrAll -Count $countRand);
					$password = $pwdCharsLower + $pwdCharsUpper + $pwdCharsNum + $pwdCharsRandom
				} else {
					$password = $pwdCharsLower + $pwdCharsUpper + $pwdCharsNum
				}
			[string]$shuffPW = $(shuffle $password)
			#return Join-String $(shuffle $password)
			return $shuffPW.replace(" ","")
			}
		#ENDREGION Get-PasswordChars
	
	if ($Length -lt $($Lower + $Upper + $Numeric)) {
		Write-Host "Password Length $Length" -foregroundcolor red -BackgroundColor yellow -NoNewline;
		Write-Host " is too short for $Lower Lowercase, $Upper Uppercase, and $Numeric Numerical characters"; `
		exit
	}
	$Random = $Length - $($Lower + $Upper + $Numeric)
	$i = 1
	while ($i -le $genNum) {
		Get-PasswordChars $Length $Lower $Upper $Numeric $Random; $i +=1 
		}
	}
#ENDREGION New-Password

#REGION Remove-Diacritics
function Remove-Diacritics([string]$String)
{
    $objD = $String.Normalize([Text.NormalizationForm]::FormD)
    $sb = New-Object Text.StringBuilder

    for ($i = 0; $i -lt $objD.Length; $i++) {
        $c = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($objD[$i])
        if($c -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
          [void]$sb.Append($objD[$i])
        }
      }

    return("$sb".Normalize([Text.NormalizationForm]::FormC))
}
#ENDREGION Remove-Diacritics

#REGION Remove-SpecialChars
function Remove-SpecialChars($Text){
	[System.Text.RegularExpressions.Regex]::Replace($Text,"[^1-9a-zA-Z_.]","")
}
#ENDREGION Remove-SpecialChars

#REGION Get-OUPath
#TODO Define switches for rest of Departments/OU variable creation
function Get-OUPath($object){
	#Lookup OUPath based on Office and Division
	$ouPath = switch ($object.office){
			{@("Atlanta","New York","Minneapolis","San Francisco") -contains $_}{
				switch -wildcard ($object.extensionattribute4){
					"M0511"{"OU=CapAdv,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L3511"{"OU=CFOA,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L4011","M1511") -contains $_}{"OU=CIOA,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L9011","L9211","M2511","M6011") -contains $_}{"OU=CG,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"M1011"{"OU=CT,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L7011"{"OU=FSS,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L1011","M2011") -contains $_}{"OU=GFS,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L7511"{"OU=HCG,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L8011"{"OU=HRM,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L3011"{"OU=PS,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L0511","L0512","L0513","L0514","L0515","L0516","M6511","M7011","M7511","M3011","M3511","M4011","M4511","M5011") -contains $_}{"OU=Corporate,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L9511"{"OU=STS,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L2511"{"OU=TIMES,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L6011"{"OU=UI,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
					"L8511"{"OU=BAprog,OU=NA,OU=Employees,DC=kurtsalmon,DC=com"}
				}
			}
			{@("Tokyo","China") -contains $_}{
				"OU=CG,OU=AP,OU=Employees,DC=kurtsalmon,DC=com"
			}
			{@("London","Manchester","Düsseldorf") -contains $_}{
				switch -wildcard ($object.extensionattribute4){
					"M0511"{"OU=CapAdv,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L3511"{"OU=CFOA,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L4011","M1511") -contains $_}{"OU=CIOA,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L9011","M2511","M6011") -contains $_}{"OU=CG,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"M1011"{"OU=CT,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L7011"{"OU=FSS,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L1011","M2011") -contains $_}{"OU=GFS,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L7511"{"OU=HCG,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L8011"{"OU=HRM,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L3011"{"OU=PS,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					{@("L0511","L0512","L0513","L0514","L0515","L0516","M6511","M7011","M7511","M3011","M3511","M4011","M4511","M5011") -contains $_}{"OU=Corporate,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L9511"{"OU=STS,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L2511"{"OU=TIMES,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L6011"{"OU=UI,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
					"L8511"{"OU=BAprog,OU=EU,OU=Employees,DC=kurtsalmon,DC=com"}
				}	
			}
		}
	$ouPath
#	$object | Add-Member NoteProperty -Name OUpath $ouPath	
}	
#ENDREGION Get-OUPath

#REGION Get-MBXdatabase
	function Get-MBXdatabase($object){	
		$MBXdatabase = switch -wildcard	($object.OUpath){
			"*,OU=EU,*" {"CN=EU Standard Mailboxes,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=Corporate,OU=NA,*" {"CN=Corporate,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=CG,OU=NA,*"{"CN=North America CPD Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=CIOA,OU=NA,*"{"CN=North America CPD Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=GFS,OU=NA,*"{"CN=North America CPD Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=CapAdv,OU=NA,*"{"CN=SECCAS Archive Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=HCG,OU=NA,*"{"CN=North America HCG Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"*,OU=AP,*"{"CN=North America CPD Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
		}
		$MBXdatabase
	}
#ENDREGION Get MBXdatabase

#REGION New-ksExMailboxSB
#TODO Finish Exchange Database selection
	function New-ksExMailboxSB($object){
		switch($object.OUPath){
			"*,OU=EU,*" {$database = "CN=EU Standard Mailboxes,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=Corporate,OU=NA,*" {$database = "CN=Corporate,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=CG,OU=NA,"{$database = "CN=North America CPD Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=CapAdv,OU=NA,*"{$database = "CN=SECCAS Archive Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"OU=HCG,OU=NA,*"{$database = "CN=North America HCG Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
			"*,OU=AP,*"{$database = "CN=APAC Exchange Database,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=KSA,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=kurtsalmon,DC=com"}
		}
		$object.distinguishedname | Enable-Mailbox -Database $database -scljunkenabled:$true -scljunkthreshold:4
	}
#ENDREGION New-ksExMailboxSB

#REGION format-OutHeader
function format-OutHeader($object){
#TODO Complete Output File Header
	$object | Select-Object I_ROW_FLAG,EMPLID,@{
		name="EMAIL";expression={[string]$ID = $object.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties mail).mail}
		},@{
		name="LOGIN";expression={[string]$ID = $object.EMPLID; $(Get-Aduser -filter {ExtensionAttribute2 -eq $ID} -properties SAMAccountName).SAMAccountName} 
		}
	}
#ENDREGION format-OutHeader

#REGION Export-PSADFile
function Export-PSADFile($object){
#TODO Complete Output PSAD File
	
 	$ADHRUsers =  $(foreach ($obj in $object) {format-OutHeader $obj}) 
	$ADHRUsers | Export-Csv $ADHRFile -NoTypeInformation -Encoding UTF8 -Delimiter ";" 
}
#ENDREGION Export-PSADFile

#REGION Compare-ValuesEmptyNullEqual 
function Compare-ValuesEmptyNullEqual($string1,$string2)
{
	if ([system.string]::isnullorempty($string1)){
		if ([system.string]::isnullorempty($string2)){$result = $true}
	else{
		if ($string1 -ne $string2){
			$result = $false
			}
		}	
	}else{
		if ($string1 -ne $string2){
			$result = $false
		}else{$result = $true}
	}
	$result
}
#ENDREGION Compare-ValuesEmptyNullEqual

#ENDREGION SubFunctions

# SIG # Begin signature block
# MIINxQYJKoZIhvcNAQcCoIINtjCCDbICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVPelK4UZTtPs0IU9j05VuVne
# y4Cgggu5MIIFoDCCBIigAwIBAgIKRJHmZwAAAAAg7TANBgkqhkiG9w0BAQUFADBI
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
# FgQUgRyIYkHCGzvP9YBWy5zgCck5DA0wDQYJKoZIhvcNAQEBBQAEgYAs76RoH7VD
# BdKyjrJEtLB5Jmb/DxSipOiDgmNqQ3NqZY/aFMMr/jQ/chTCQEt/5t8Rtu3ZGsHw
# Kg7+AJjV3KucpXVIoiGeeFhP8KQxQoahy+oDUsIAGiO5yEm5+P5cd1cjZ0WbvA3W
# aU8XZPTsdJEhG6onA/imfIcvlpVj5fqZVA==
# SIG # End signature block
