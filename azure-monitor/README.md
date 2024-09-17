## Integration with Azure Monitor

uberAgent can be configured to send the collected data to Microsoft Azure Monitor (Log Analytics).    
The configuration steps are captured in the [documentation](https://docs.citrix.com/en-us/uberagent/7-3-0/installation/backend/configuring-microsoft-azure-oms-log-analytics).

Different tools can then be used to visualize the collected and stored metrics. Pre-built dashboard definitions can be found for
* Azure Workbooks
* Grafana
* PowerBI


### Creating Azure Log Analytics workspace

1. Log in to the Azure portal
2. In all services, search for Log Analytics workspaces.
![image](docImages/LogAnalyticsWorkspaceSearch.png) 
3. Create a new workspace within the desired Subscription and Resource group

### Integrating uberAgent with Log Analytics workspace

1. Once uberAgent is installed in the required machine, go to the installed location. (By default would be : `C:\Program Files\vast limits\uberAgent`)
2. Open the `uberAgent.conf` file and add the following Receiver entry in it. 

```
[Receiver]
Name = Default
Type = OMSLogAnalytics
Protocol = HTTP				
Servers = https://<log-analytics-workspace-id>.ods.opinsights.azure.com
RESTToken = <log-analytics-primary key>
```
* Workspace ID and Primary Key can be found in : Settings →  Agents → Log Analytics agent instructions
![image](docImages/AzureWSAgentPage.png) 

3. Restart the uberAgent service, and it should start sending data to the Log Analytics workspace.
4. Verify if the data is received in Logs → Custom Logs to see the tables created
![image](docImages/AzureWSTables.png) 
   