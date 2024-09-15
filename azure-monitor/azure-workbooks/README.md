## How to deploy the Azure Workbooks

Currently, 2 types of workbook files are provided:
* A workbook file, which only includes the workbook definition
* An ARM template json file, which includes both the ARM template and the workbook definition

### Deploy a workbook using Azure portal

Users can deploy individual workbooks through the Azure portal, by following the steps:

- In the Github repository, open the workbook file (.workbook) of interest and view it in "Raw" mode
- Copy the file contents to the clipboard
- In the Azure portal, navigate to the Azure Log Analytics Workspace which has been configured to store the collected uberAgent metrics
- In the menu, navigate to "Monitoring" > "Workbooks"
- Click "New"
- Click the icon of "Advanced Editor"
- If not already selected, select the "Gallery Template" tab

- Paste the workbook contents (replace any existing text)
- Click "Apply", "Done editing" and then the "Save" button
- A prompt for populating some parameters will pop-up:
   - Title: Set a unique workbook title
   - Subscription
   - Resource Group
   - Location
- Finally click "Apply" to save the parameter values and "Save" to store the workbook.

The newly created workbook can be found under the Log Analytics Workspace > Workbooks list. It can also be found in the parent Resource Group.


### Deploy a workbook using ARM templates and Azure Powershell

Another option is to deploy the workbook using ARM templates and Azure Powershell (or other programming options provided by Azure).

A prerequisite is the installation of [Azure Powershell](https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows).

The following commands can be executed in a Powershell environment:

```
# Log in Azure
Login-AzureRmAccount;

# Select the Subscription that will host the resources
Select-AzureRmSubscription -SubscriptionID "<SUBSCRIPTIONID>";

# Deploy the workbook
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName "<RESOURCEGROUP>" `
    -TemplateUri "https://github.com/citrix/uberagent-integrations/azure-monitor/azure-workbooks/WORKBOOK-ARM-TEMPLATE-NAME.json" `
    -workbookDisplayName "WORKBOOK-DISPLAY-NAME" `
    -workbookSourceId "LOGANALYTICS-RESOURCE-ID"

# Example with the above placeholder values populated
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName "azuremonitorrg" `
    -TemplateUri "https://github.com/citrix/uberagent-integrations/azure-monitor/azure-workbooks/Session Usage ARM.json" `
    -workbookDisplayName "Session Usage" `
    -workbookSourceId "/subscriptions/1a2b3c4d-1a2b-1a2b-1a2b-1a2b3c4d5e6f/resourcegroups/azuremonitorrg/providers/microsoft.operationalinsights/workspaces/uberagentwspace"
```
The newly created workbook can be found under the Log Analytics Workspace > Workbooks list. It can also be found in the parent Resource Group.