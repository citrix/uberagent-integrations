# Script to deploy an Azure Workbook usin ARM template

$subscriptionId = '<SUBSCRIPTIONID>'
$resourceGroupName = '<RESOURCEGROUP>'
$templateUri = 'https://github.com/citrix/uberagent-integrations/azure-monitor/azure-workbooks/WORKBOOK-ARM-TEMPLATE-NAME.json'
$workbookSourceId = '<LOGANALYTICS-RESOURCE-ID>'

# Log in
Write-Host "Logging in...";
Login-AzureRmAccount;

# Select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

# Check if resource group exists
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup) {
    Write-Host "Resource group '$resourceGroupName' does not exist. Please reference an existing resource group.";
    return
}

Write-Host "Starting deployment...";
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $templateFilePath

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateUri $templateUri `
    -workbookSourceId $workbookSourceId