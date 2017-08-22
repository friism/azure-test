param(
    [Parameter(Mandatory=$true)]
    [string]$location,
    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,
    [Parameter(Mandatory=$true)]
    [string]$resourcePrefix,    
    [Parameter(Mandatory=$true)]
    [string]$sshPublicKey,

    [string]$ucpVersion='2.2.0',
    [string]$dtrVersion='2.3.0',
    [string]$dockerVersion='17.06.1',        
    [string]$dockerWindowsVersion='17.06.1-ee-1',    
    [string]$dockerLinuxVersion='17.06.1~ee~1-0',
    [string]$vmSize='Standard_D2_v2',
    [string]$storageAccountType='Standard_LRS',
    [int]$workerCount=3
)

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Force

$adminCredential = $Host.ui.PromptForCredential('DDC credentials', 'User name and password to set for the administrator', 'docker', '')

$parameters = @{ 
    'workerCount' = $workerCount; 
    'prefix' = $resourcePrefix; 
    'adminUsername' = $adminCredential.UserName; 
    'adminPassword' = $adminCredential.GetNetworkCredential().password; 
    'sshPublicKey' = $sshPublicKey; 
    'ucpVersion' = $ucpVersion; 
    'dtrVersion' = $dtrVersion; 
    'dockerVersion' = $dockerVersion;
    'dockerWindowsVersion' = $dockerWindowsVersion;
    'dockerLinuxVersion' = $dockerLinuxVersion;
    'vmSize' = $vmSize;
    'storageAccountType' = $storageAccountType;
}

New-AzureRmResourceGroupDeployment `
  -ResourceGroupName $resourceGroupName `
  -TemplateUri 'https://raw.githubusercontent.com/sixeyed/azure-test/master/azuredeploy.json' `
  -TemplateParameterObject $parameters `
  -Verbose