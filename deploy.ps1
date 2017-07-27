param(
    [Parameter(Mandatory=$true)]
    [string]$region,
    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,
    [Parameter(Mandatory=$true)]
    [string]$resourcePrefix,    
    [Parameter(Mandatory=$true)]
    [string]$sshPublicKey,

    [string]$ucpVersion='latest',
    [string]$dtrVersion='2.3.0-tp6',
    [string]$dockerVersion='17.06.0-ce',
    [string]$vmSize='Standard_D2_v2',
    [string]$storageAccountType='Standard_LRS',
    [int]$workerCount=1
)

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Force

$adminCredential = $Host.ui.PromptForCredential('DDC credentials', 'User name and password to set for the administrator', 'docker', '')
$hubCredential = $Host.ui.PromptForCredential('Docker Hub credentials', 'User name and password for Docker Hub', '', '')

$parameters = @{ 
    'hubUsername'= $hubCredential.UserName; 
    'hubPassword' = $hubCredential.GetNetworkCredential().password; 
    'workerCount' = $workerCount; 
    'prefix' = $resourcePrefix; 
    'adminUsername' = $adminCredential.UserName; 
    'adminPassword' = $adminCredential.GetNetworkCredential().password; 
    'sshPublicKey' = $sshPublicKey; 
    'ucpVersion' = $ucpVersion; 
    'dtrVersion' = $dtrVersion; 
    'dockerVersion' = $dockerVersion;
    'vmSize' = $vmSize;
    'storageAccountType' = $storageAccountType;
}

New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $resourceGroupName `
  -TemplateUri 'https://raw.githubusercontent.com/sixeyed/azure-test/master/azuredeploy.json' `
  -TemplateParameterObject $parameters `
  -Verbose