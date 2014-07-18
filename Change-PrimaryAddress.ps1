﻿Function Change-PrimaryAddress ($alias, $newPrimaryAddress)
{
  $mailbox = Get-Mailbox $alias
  $mailbox.emailAddresses+= $newPrimaryAddress
  $mailbox.primarysmtpaddress = $newPrimaryAddress
  Set-Mailbox $mailbox.identity -EmailAddressPolicyEnabled $false
  Set-Mailbox $mailbox.identity -emailAddresses $mailbox.emailAddresses
  Set-Mailbox $mailbox.identity -PrimarySmtpAddress $mailbox.primarysmtpaddress
}
# SIG # Begin signature block
# MIIPAAYJKoZIhvcNAQcCoIIO8TCCDu0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaX9gANEFNNrXGts0CtppDsfB
# zC2gggxzMIIGETCCA/mgAwIBAgIKYTLgOwAAAAAAAjANBgkqhkiG9w0BAQUFADBH
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUuZyj
# 0pzwV4cB7cS10bzg8wxjMvwwDQYJKoZIhvcNAQEBBQAEggEAVCVOX+il55TgZRCo
# pCCoPOCnBj/Aj9crnWfbmwbLEgNdqz3VH1j4VCUzmYu86uEceBuvGSqr4ww1eQj/
# VVgD0esr4DusnPkF0/EPmiywIy/pZI6ClyQlr72D4wQQfv/UYhnSLoJ8Sx5+/mc5
# AK4ymjjeZCow7mAKMWUXO5jJd/pzD3nSnYCm2N4lchaA52OatdgvHi2VC0OAe6di
# 3ojsWk4z0NPBrjI/CPOUSZmT1ndQuGW8bsxgcN7+LeLGlLtuhrzLVWkAAfwP5rON
# QPjYohHVHvWzKHGS36qkxG7sjoQjYHj/3otthVKsnLUwq+BAqFTq2xRY81SsLYsU
# BfuC8g==
# SIG # End signature block
