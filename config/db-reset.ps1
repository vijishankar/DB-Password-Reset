param(
[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [String] $ResourceGroupName,
[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [String] $SeverName,
[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [String] $KeyVaultName,
[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [String] $SecretName,
[Parameter(ValueFromPipeline=$true)] [String] $SecretValue
)

#$ResourceGroupName = "DB-Rest-Passwd"
#$SeverName = "sqlserve123456"
#$KeyVaultName = "secret-db-passwd"
#$SecretName = "password"

$sqlserver = Get-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SeverName -ErrorVariable notPresent -ErrorAction SilentlyContinue
$keyVault= Get-AzKeyVault -VaultName $keyVaultName -ErrorVariable notPresent -ErrorAction SilentlyContinue


function changePassword()
{
if($sqlserver)
{

#Generating Random Password from RandomCharacters Method
$Resetpassword = -join((65..90) + (97..122) + (58..64) + (58..64) + (32..47) | Get-Random -Count 15 | % {[char]$_})
Write-Host $Resetpassword
Write-Output $Resetpassword


#Updating the password
$SecureStringpwd = ConvertTo-SecureString $Resetpassword -AsPlainText -Force
Set-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SeverName -SqlAdministratorPassword $SecureStringpwd

Write-Host $newpsswd
Write-Output $newpsswd

if($SecretValue -ne $SecureStringpwd)
{
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $SecretName -SecretValue $SecureStringpwd
Write-Output "SecretValue updated"
}
}

else{
Write-Host "There is no Sql Server in the given Resource Group"
}

}

changePassword
