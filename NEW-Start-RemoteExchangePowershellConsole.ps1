
if ($(get-host).name -eq "PowerShellPlus Host"){$psplus.Tabs.SetSelectedTab("Console")}
$exPol = $(Get-ExecutionPolicy).ToString()
if ($exPol -ne "RemoteSigned"){
Write-Host -ForegroundColor black -BackgroundColor red "**WARNING Setting ExecutionPolicy to RemoteSigned**"
Set-ExecutionPolicy RemoteSigned -Scope Process -Force 
}

$ExServer = Read-Host "Enter Exchange ServerName"
if (Test-Path "C:\DevelopmentWorkspace\Network Group - Development-Branch\PowerShell Scripts\KSA _Email\AdminCred.clixml"){
$AdminCred = Import-Clixml "C:\DevelopmentWorkspace\Network Group - Development-Branch\PowerShell Scripts\KSA _Email\AdminCred.clixml"}
else{$AdminCred = Get-Credential
}
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionURI http://$ExServer/PowerShell/ -Authentication Kerberos -Credential $AdminCred
Import-PSSession $Session

$Session2 = New-PSSession -ComputerName ksa2008dc -Authentication Kerberos -Credential $AdminCred
Invoke-Command -ScriptBlock {Import-Module ActiveDirectory} -Session $Session2
Import-PSSession $Session2 -Module ActiveDirectory

if ($exPol -ne "RemoteSigned"){
Write-Host -BackgroundColor yellow -ForegroundColor Black "**Resetting ExecutionPolicy to $exPol**"
Set-ExecutionPolicy $exPol -Scope process -force
}
