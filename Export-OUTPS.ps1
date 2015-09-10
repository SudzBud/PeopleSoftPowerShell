﻿$importfilePath = "C:\PeopleSoftPowershell\HRRPTIN\"
$importfiles = Get-ChildItem -path $importfilePath -Exclude "*utf8*" | Where-Object {$_.extension -eq ".csv"}
$exportfilepath = "C:\PeopleSoftPowerShell\HRRPTOUT\"

#REGION format-OutHeader
function format-OutHeader($object){
#TODO Complete Output File Header
	$ID = $object.EMPLID
	if ($object.I_ROW_FLAG -eq "C"){
		$userObj = $(Get-Aduser -filter "ExtensionAttribute2 -eq $ID" -properties mail,SAMAccountName)
	}
	$getmail = $userObj.mail
	$getlogin = $userObj.SAMAccountName
	if (!($getmail)){$getmail = ""}
	if (!($getlogin)){$getlogin = ""}
	$object | Select-Object I_ROW_FLAG,EMPLID,@{name="EMAIL";expression={$getmail}},@{name="LOGIN";expression={$getlogin}}
	}
#ENDREGION format-OutHeader

foreach ($importfile in $importfiles){
	[array]$importfiledata = $(Import-Csv $importfile -Delimiter ";")
	$outfiledata = $($importfiledata | Where-Object {$_.I_ROW_FLAG -ne "M"} | ForEach-Object {format-OutHeader $_} )
	$exportfile = $exportfilepath + $($importfile.basename.replace("HRAD","ADHR")) + ".csv"
	if ($outfiledata) {$outfiledata | Export-Csv $exportfile -NoTypeInformation -Encoding UTF8 -Delimiter ";"}
	$importfiledata = $null
	$outfiledata = $null
}

#ENDREGION SubFunctions
# SIG # Begin signature block
# MIINxQYJKoZIhvcNAQcCoIINtjCCDbICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrFkYUF5H5Z1M9r9KGYAzzsa3
# KLmgggu5MIIFoDCCBIigAwIBAgIKRJHmZwAAAAAg7TANBgkqhkiG9w0BAQUFADBI
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
# FgQUlsli63lP5US5ydat0tJjmLl1fmgwDQYJKoZIhvcNAQEBBQAEgYCGyQrGnHAm
# F2X46wvfwsU/EZNgOpjDhbWjKADPG87+Oi+ra/zEI8HKZLkFi2mmps49m+Ee8IbZ
# YC5hkmDxD6ttBlq1RAqRWh4LonR+y/7rB2HFDzKM2WXpGvHPok9PrYpnrdmGsPJZ
# wvBUqbzxxtYKSH3AteurYa2Nml4+ChUtJw==
# SIG # End signature block
