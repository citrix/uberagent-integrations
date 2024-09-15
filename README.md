## uberAgent Integration and Dashboards

uberAgent is a User Experience Monitoring (UXM) and Endpoint Security Analytics (ESA) tool that provides in-depth visibility into user experience, system performance, and security across physical and virtual endpoints.


uberAgent can send collected metrics directly to **platforms** like:
* Splunk
* Elastic
* Azure Monitor (Log Analytics)

uberAgent can also send collected metrics to other platforms, indirectly via the supported Kafka interface:
* Dynatrace
* Datadog

Pre-built dashboards are available for the above platforms, backed by different Visualization tools:

| Platform / Backend | Visualization |
| ---------------- | ------------- |
| Splunk   | uberAgent UXM and ESA Splunk apps |
| Elasticsearch | Kibana dashboards |
| Azure Monitor (Log Analytics) | Azure Workbooks |
| Azure Monitor (Log Analytics) | Grafana |
| Azure Monitor (Log Analytics) | PowerBI |
| Datadog | Datadog Dashboards
| Dynatrace | Dynatrace Dashboards