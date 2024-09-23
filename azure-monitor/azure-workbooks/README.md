## Connecting Uber Agent Metrics to Azure Workbook


This document will walk you through the steps to connect "UberAgent" installed in your Citrix components to the Azure Workbook through Azure Log Monitor and visualize them in a dashboard. 

### Table of contents
  - [Creating Azure Log Analytics workspace](#creating-azure-log-analytics-workspace)
  - [Integrating uberAgent with Log Analytics workspace](#integrating-uberagent-with-log-analytics-workspace)
  - [Import Azure workbook templates to your Azure Log Analytics Workspace](#import-azure-workbook-templates-to-your-azure-log-analytics-workspace)
    - [Step 1 - Create a new "Log analytics workspace" in Azure or use an existing one](#step-1---create-a-new-log-analytics-workspace-in-azure-or-use-an-existing-one)
    - [Step 2 - Use powershell script or workbook files import the templates to your workspace](#step-2---use-powershell-script-or-workbook-files-import-the-templates-to-your-workspace)
    - [Option 1 : Use powershell](#option-1--use-powershell)
    - [Option 2 : Use the workbook files in the repo and manually add them to your workspace](#option-2--use-the-workbook-files-in-the-repo-and-manually-add-them-to-your-workspace)
      - [Importing workspace files](#importing-workspace-files)
      - [Linking the workspaces](#linking-the-workspaces)


### Creating Azure Log Analytics workspace

[Creating Azure Log Analytics workspace](../README.md#creating-azure-log-analytics-workspace)

### Integrating uberAgent with Log Analytics workspace

[Integrating uberAgent with Log Analytics workspace](../README.md#integrating-uberagent-with-log-analytics-workspace)
   

### Import Azure workbook templates to your Azure Log Analytics Workspace

#### Step 1 - Create a new "Log analytics workspace" in Azure or use an existing one


* Navigate to the azure portal
* Search for "Log analytics workspace" and go to the dedicated page
* Click on the workspace to which you are sending the data (Configured in previous section)
* Note down the "Resource Group", "Workspace Name" and "Subscription ID"
* Make sure your account has the necessary permissions to create a new workspace to CLI
  

 ![image](img/AzureMonitorInfoPage.png)


#### Step 2 - Use powershell script or workbook files import the templates to your workspace

You can either use the [powershell script](https://github.com/citrix/uberagent-integrations/blob/main/azure-monitor/azure-workbooks/ImportWorkbooks.ps1) in the repo or manually add the individual workbooks to import the workbooks.


#### Option 1 : Use powershell

* Download the [powershell script](https://github.com/citrix/uberagent-integrations/blob/main/azure-monitor/azure-workbooks/ImportWorkbooks.ps1) from the repo
* Open "Powershell"
* Navigate to the folder to which you have downloaded the ps1 file
* Make sure you have the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) installed in your machine
* Login to your account by running `az login`
* Navigate to the AzureWorkbook folder
* run the powershell script by running `.\ImportWorkbooks.ps1`
* It will ask for "Subscription Id", "Resource Group Name" and "Workspace Name"
* You can copy the values from Azure Portal and paste them in the CLI by mouse right click
* The script will import the templates to your Azure Workbooks

#### Option 2 : Use the workbook files in the repo and manually add them to your workspace

##### Importing workspace files

* Navigate to [Workbooks](https://github.com/citrix/uberagent-integrations/tree/main/azure-monitor/azure-workbooks/workbooks) folder in the repo
* Open the first workbook file and copy the contents
* Open Azure portal and navigate to your Log Analytics Workspace.
* Click on "+New" icon
![image](img/NewWorkbookNavigation.png)
* In the "New" screen, click on advanced editor
![image](img/AdvancedEditor.png)
* Paste the contents you copied from workspace file in "Gallery Template" tab
* Click "Apply", "Done editing" and then the "Save" button
* A prompt for populating some parameters will pop-up:
   - Title: Set a unique workbook title
   - Subscription
   - Resource Group
   - Location
* Finally click "Apply" to save the parameter values and "Save" to store the workbook.
* Repeat the same for all files

The newly created workbook can be found under the Log Analytics Workspace > Workbooks list. It can also be found in the parent Resource Group.

##### Linking the workspaces
The `citrix_session_configuration_details` and `citrix_machine` can be linked to `citrix_session_single_user_details` and `citrix_single_machine_details` workbooks respectively to have a seamless drill-down view. Follow these steps

* in the "Workbooks" home page, in the tile corresponding to "citrix_single_machine_details", click on the 3 dots and select "View Resource"
* Copy the resource id
![image](img/CopyResourceID.png)
* Go back to "Workbooks" home page and click on the tile corresponding to the "citrix_session_configuration_details" and open the workbook
* Click on "Edit" and go to "advanced editor"
![image](img/AdvancedEditor.png)
* In the Gallery template tab, search for "templateId".
* Replace the TemplateId with the resource id of "citrix_single_machine_details" - The one you copied in the previous step
* Click "Apply", and Save the workbook by pressing "Save" icon
* Repeat the same for citrix_single_machine_details by copying the resource id and pasting that resource id in the gallery template of citrix_machine workbook



