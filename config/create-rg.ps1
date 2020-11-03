param(
    $RGName
    )
$location = 'East US'
$resourceGroupName = $RGName

Write-Host "Starting to Create the Key Vault" 

# Create new resource group if not exists.
$rgAvail = Get-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction SilentlyContinue
if(!$rgAvail){
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}
