param (
    [string]$SubscriptionId,
    [string]$WorkspaceName,
    [string]$ResourceGroup
)

function DownloadFiles{ 
    param (
        [string[]]$OriginalFiles
    )
    foreach ($FileName in $OriginalFiles) {
        $Url = "https://raw.githubusercontent.com/citrix/uberagent-integrations/refs/heads/main/azure-monitor/azure-workbooks/arm-templates/$FileName"
        $Output = $FileName
        Invoke-WebRequest -Uri $url -OutFile $Output
        Write-Host "Downloaded $FileName"
    }
}

function CopyFiles{ 
    param (
        [string[]]$OriginalFiles,
        [string]$NewPrefix
    )
    foreach ($FileName in $OriginalFiles) {
        $NewFileName = $NewPrefix + $FileName
        $OrigFilePath = $FileName
        Copy-Item -Path $OrigFilePath -Destination $NewFileName
        Write-Host "Copied $FileName to $NewFileName"
    }
}



function DeleteFiles{
    param (
        [string[]]$OriginalFiles,
        [string]$NewPrefix
    )
    foreach ($FileName in $OriginalFiles) {
        $CopyFileToDelete = $NewPrefix + $FileName
        if (Test-Path $FileName) {
            Remove-Item -Path $FileName -Force
            Write-Host "File '$FileName' deleted successfully."
        } else {
            Write-Host "File '$FileName' does not exist."
        }
        if (Test-Path $CopyFileToDelete) {
            Remove-Item -Path $CopyFileToDelete -Force
            Write-Host "File '$CopyFileToDelete' deleted successfully."
        } else {
            Write-Host "File '$CopyFileToDelete' does not exist."
        }
    }
}

function ReplaceDrilldownLink{
    param (
        [string]$FileName,
        [string]$WorkbookId,
        [string]$ResourceGroup,
        [string]$SubscriptionId
    )
    $WorkbooksourceId = "/subscriptions/"+$SubscriptionId+"/resourceGroups/"+$ResourceGroup+"/providers/microsoft.insights/workbooks/"+$workbookId
    $FileContent = Get-Content -Path $FileName
    $NewContent = $FileContent.Replace("<<<REPLACEHERE>>>", $WorkbooksourceId)
    Set-Content -Path $FileName -Value $NewContent

}


function importFiles{
    param (
        [string]$SubscriptionId,
        [string]$ResourceGroup,
        [string]$WorkspaceName,
        [string[]]$OriginalFileNames,
        [string[]]$WorkbookIds,
        [string]$NewPrefix
    )
    
    for ($i = 0; $i -lt $OriginalFileNames.Length; $i++) {
        $FileName = $NewPrefix+$OriginalFileNames[$i]
        $WorkbookId = $WorkbookIds[$i]
        $workbooksourceId = "/subscriptions/"+$SubscriptionId+"/resourceGroups/"+$ResourceGroup+"/providers/Microsoft.OperationalInsights/workspaces/"+$WorkspaceName
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup `
            -TemplateFile $FileName `
            -TemplateParameterObject @{
                "workbookSourceId" = $workbookSourceId
                "workbookId" = $workbookId
            }
    }
}

#check if the user has already passed the details as cli arguments. If not, prompt the user to enter the details
if (-not $subscriptionId) {
    $subscriptionId = Read-Host "Enter your Azure subscription ID: "
}

if (-not $workspaceName) {
    $workspaceName = Read-Host "Enter the Log Analytics workspace name"
}

if (-not $resourceGroup) {
    $resourceGroup = Read-Host "Enter the resourceGroup name"
}

Set-AzContext $SubscriptionId


#************************ Edit here when you want to add more templates ********************************
#The list of arm template files of the workbooks we need to import. The IDs will be taken from this array
#DO NOT CHANGE THE ORDER OF THE FILES AND IDS
$OriginalFileNames = @("citrix_application_usage.json", "citrix_machines.json", "citrix_session_configuration_details.json", "citrix_single_machine_detail.json", "citrix_session_single_user_detail.json")
$WorkbookIds = @("e000970a-6da8-45a2-8265-eebc7709b0a1", "e000970a-6da8-45a2-8265-eebc7709b08f", "e000970a-6da8-45a2-8265-eebc7709b02e", "2b17cd9b-b615-4dff-9215-570bcae0c031", "c2b60e6a-a702-4703-92ff-3a0bbed5a028")

# This part is used for linking different workbooks. If you need to link a workbook to another workbook, 
# you can add the source workbook name and destination workbook ID here. Make 
$ReplacementNeededFileNames = @( 'citrix_machines.json', 'citrix_session_configuration_details.json')
$ReplacementNeededIds = @("2b17cd9b-b615-4dff-9215-570bcae0c031", "c2b60e6a-a702-4703-92ff-3a0bbed5a028")
#******************************************************************************************************



$NewPrefix = "temp_"

DownloadFiles -OriginalFiles $OriginalFileNames
CopyFiles $originalFileNames $newPrefix;

for ($i = 0; $i -lt $ReplacementNeededFileNames.Length; $i++) {
    $FileName = $NewPrefix+$ReplacementNeededFileNames[$i]
    $id = $ReplacementNeededIds[$i]
    ReplaceDrilldownLink -FileName $FileName -WorkbookId $id -SubscriptionId $SubscriptionId -ResourceGroup $ResourceGroup -NewPrefix $NewPrefix
}

importFiles -SubscriptionId $SubscriptionId -WorkspaceName  $WorkspaceName -ResourceGroup $ResourceGroup -OriginalFileNames $OriginalFileNames -WorkbookIds $WorkbookIds -NewPrefix $NewPrefix
DeleteFiles $OriginalFileNames $NewPrefix;

Write-Host "Deployment Completed. Please check the workbooks in the Azure portal if you are not seeing any explicit error message in terminal. It may take uip to 15 mins for the workbooks to appear in the portal."