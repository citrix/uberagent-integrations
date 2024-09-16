
## Integrating uberAgent with Datadog and importing dashboards

### Table of contents
- [uberAgent integration with Datadog](#uberagent-integration-with-datadog)
- [Configuring Logstash to read from Kafka](#configuring-logstash-to-read-from-kafka)
- [Configuring Logstash to forward records to Datadog](#configuring-logstash-to-forward-records-to-datadog)
- [References](#references)


### uberAgent integration with Datadog

uberAgent does not currently directly integrate with platforms like Datadog. Thus, an indirect integration path needs to be followed. This involves the use of a Kafka instance and a Logstash instance.

![image](img/uberagent-datadog-integration.png)

- **Kafka** is already supported as an uberAgent output sink. It can be deployed locally or on the cloud, on a dedicated VM or AKS cluster, on a set of VMs or even in the form of docker containers. The deployment style depends on the customer infrastructure and the CVAD setup size which determines the uberAgent metric volume.
- **Logstash** can be used as a data forwarding vehicle between Kafka and Datadog. It can also be installed locally or on the cloud, on a VM or as a docker container, depending on the record volume it is expected to process and forward.   
Logstash was chosen as it supports Kafka as an input plugin and Datadog as an output plugin. It also supports message deserialization, as uberAgent uses Avro as message format.

The current documentation will not cover in detail the installation of Kafka and Logstash, as these depend on the installation mode and can be found in their official documentation.

### Configuring Logstash to read from Kafka
The Logstash configuration for reading data from Kafka using the respective input plugin can look like below:

```
input {
  kafka {
    bootstrap_servers => "broker:29092"
    topics => [
              "uberAgent_System_SystemPerformanceSummary2",
              "uberAgent_Process_NetworkTargetPerformance",
              "uberAgent_Config_ConfigInfo",
              "uberAgentESA_Process_DnsQuery",
              "uberAgentESA_System_ScheduledTasks",
              "uberAgent_Application_UIDelay",
              "uberAgent_System_GpuUsageEngine",
              "uberAgent_Process_ProcessDetail",
              "uberAgentESA_System_ScheduledTaskTriggers",
              "uberAgentESA_System_ScheduledTaskActions",
              "uberAgent_Session_SessionDetail",
              "uberAgent_System_GpuUsage"
            ]
    group_id => "logstash_group"
    auto_offset_reset => "earliest"
    schema_registry_url => "http://schema-registry:8081"
  }
}
```
In the above configuration, please replace the 
 - `bootstrap_servers` value with the correct list of bootstrap servers and their port.
 - `group_id` value with the Kafka consumer group ID of preference
 - `schema_registry_url` value with the correct schema registry URI and port

### Configuring Logstash to forward records to Datadog
The Logstash configuration for forwarding data to Datadog  using the respective output plugin can look like below:

```
output {
  datadog_logs {
    host => "http-intake.logs.us.datadoghq.com"
    api_key => "<DATADOG-API-KEY>"
  }
}
```
In the above configuration, please replace the 
 - `host` value with the correct datadog instance host URI
 - `api_key` value with a valid API key got from Datadog settings


### Importing Datadog dashboards
As part of the integration of uberAgent with Datadog, logs are configured to get ingested in Datadog.
Datadog automatically detects the log fields, allowing for dashboards to be built on top of them.

A list of pre-built dashboards is provided [here](dashboards).
The dashboards can be imported into a Datadog instances following these steps:
* In the Datadog UI, navigate to "Dashboards" > "New Dashboard".
* Click on the "New Dashboard" button in the popup.
* The Dashboard editor view comes up.
* On the top right, click "Configure" and select the option "Import dashboard JSON".
* The contents of the dashboard JSON file can be pasted in the popup, or the user can browse for a checked-out version of the dashboard file.
* Confirm the replacement of the current contents of the new dashboard.
* The imported dashboard will appear and will be populated with data.


### References

 - Kafka
	 - [Kafka documentation](https://kafka.apache.org/documentation/)
	 - [Configuring uberAgent with Kafka](https://docs.citrix.com/en-us/uberagent/current-release/installation/backend/configuring-apache-kafka-confluent-rest-proxy)
	 - [Confluent REST Proxy](https://docs.confluent.io/platform/current/kafka-rest/index.html)
	 - [Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)
 - Logstash
	 - [Logstash introduction](https://www.elastic.co/guide/en/logstash/current/introduction.html)
	 - [Kafka input plugin](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-kafka.html)
	 - [Datadog output plugin](https://www.elastic.co/guide/en/logstash/current/plugins-outputs-datadog.html)
- Datadog
	- [Datadog documentation](https://docs.datadoghq.com/)  
	- [Observe and explore logs](https://docs.datadoghq.com/logs/)  
	- [Get started with dashboards](https://docs.datadoghq.com/dashboards/)
