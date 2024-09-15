## How to import Grafana dashboards

#### Configure a Log Analytics data source

- Select "Connections" > "Data sources" > "Add new data source"
- Find and select the "Azure Monitor" data source type
- Fill the data source name and authentication information
- Click "Save & test"

#### Import a dashboard

- Navigate to "Dashboards"
- Click on the "New" button and then select "Import"
- Browse for and select the dashboard definition (.json file) to import
- Select the Azure Monitor data source configured above
- Click "Import"
- The newly imported dashboard will then open.
- In the selectors at the top, select the Subscription and the Log Analytics workspace. The data queries should then succeed and you should see the charts populated with data. If needed, you can adjust the selected time window.