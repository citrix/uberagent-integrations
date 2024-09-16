function CopyFiles{ 
    param (
        [string[]]$originalFiles,
        [string]$newPrefix
    )
    foreach ($fileName in $originalFiles) {
        $newFileName = $newPrefix + $fileName
        $origFilePath = "arm-templates/" + $fileName
        Copy-Item -Path $origFilePath -Destination $newFileName
        Write-Host "Copied $fileName to $newFileName"
    }
}



function DeleteFiles{
    param (
        [string[]]$originalFiles,
        [string]$newPrefix
    )
    foreach ($fileName in $originalFiles) {
        $fileToDelete = $newPrefix + $fileName
        if (Test-Path $fileToDelete) {
            Remove-Item -Path $fileToDelete -Force
            Write-Host "File '$fileToDelete' deleted successfully."
        } else {
            Write-Host "File '$fileToDelete' does not exist."
        }
    }
}

function ReplaceDrilldownLink{
    param (
        [string]$fileName,
        [string]$workbookId,
        [string]$resourceGroup,
        [string]$subscriptionId
    )
    $workbooksourceId = "/subscriptions/"+$subscriptionId+"/resourceGroups/"+$resourceGroup+"/providers/microsoft.insights/workbooks/"+$workbookId
    $fileContent = Get-Content -Path $fileName
    $newContent = $fileContent.Replace("<<<REPLACEHERE>>>", $workbooksourceId)
    Set-Content -Path $fileName -Value $newContent

}


function importFiles{
    param (
        [string]$subscriptionId,
        [string]$resourceGroup,
        [string]$workspaceName,
        [string[]]$originalFileNames,
        [string]$newPrefix
    )
    
    for ($i = 0; $i -lt $originalFileNames.Length; $i++) {
        $fileName = $newPrefix+$originalFileNames[$i]
        $workbooksourceId = "/subscriptions/"+$subscriptionId+"/resourceGroups/"+$resourceGroup+"/providers/Microsoft.OperationalInsights/workspaces/"+$workspaceName
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup `
            -TemplateFile $fileName `
            -TemplateParameterObject @{
                "workbookSourceId" = $workbookSourceId
            }
    }
}

#Reading the parameters from the user
$subscriptionId = Read-Host "Enter your Azure subscription ID"
$workspaceName = Read-Host "Enter the Log Analytics workspace name"
$resourceGroup = Read-Host "Enter the resourceGroup name"

Set-AzContext $subscriptionId

#If you need more files to be imported, change here
$originalFileNames = @("citrix_application_usage.json", "citrix_machines.json", "citrix_session_configuration_details.json", "citrix_single_machine_detail.json", "citrix_session_single_user_detail.json")

#If you need more files to be replaced, change here. Please make sure the order is same in file names and ids
$replacementNeededFileNames = @( 'citrix_machines.json', 'citrix_session_configuration_details.json')
$replacementNeededIds = @("a2b60e6a-a702-4703-92ff-3a0bbed5a028", "ab17cd9b-b615-4dff-9215-570bcae0c031")

$newPrefix = "temp_"

CopyFiles $originalFileNames $newPrefix;

for ($i = 0; $i -lt $replacementNeededFileNames.Length; $i++) {
    $fileName = $newPrefix+$replacementNeededFileNames[$i]
    $id = $replacementNeededIds[$i]
    ReplaceDrilldownLink -fileName $fileName -workbookId $id -subscriptionId $subscriptionId -resourceGroup $resourceGroup -newPrefix $newPrefix
}

importFiles -subscriptionId $subscriptionId -workspaceName  $workspaceName -resourceGroup $resourceGroup -originalFileNames $originalFileNames -newPrefix $newPrefix
DeleteFiles $originalFileNames $newPrefix;
