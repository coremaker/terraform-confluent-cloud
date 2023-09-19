[![Maintained by coremaker.io](https://img.shields.io/badge/maintained%20by-coremaker.io-green)](https://coremaker.io/)

# Terraform-confluent-cloud

This is a terraform module for Confluent Cloud provider which helps you build environments, clusters, topics and API Keys with restricted access on ACLs.  

# Examples

Please check the examples directory where different Kafka clusters types are used.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >= 1.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | 1.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.cluster_admin_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_api_key.manager_schema_registry_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_api_key.services_api_keys](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_environment.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/environment) | resource |
| [confluent_kafka_acl.cluster_configs](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.consumer_group_delete](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.consumer_group_describe](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.consumer_group_read](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.consumer_group_write](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.read](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.write](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_cluster.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_cluster) | resource |
| [confluent_kafka_topic.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_topic) | resource |
| [confluent_role_binding.cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |
| [confluent_schema_registry_cluster.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/schema_registry_cluster) | resource |
| [confluent_service_account.cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |
| [confluent_service_account.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |
| [confluent_schema_registry_region.main](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/schema_registry_region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dedicated_cluster_cku"></a> [dedicated\_cluster\_cku](#input\_dedicated\_cluster\_cku) | The number of Confluent Kafka Units for Dedicated cluster types. The minimum number of CKUs for SINGLE\_ZONE dedicated clusters is 1 whereas MULTI\_ZONE dedicated clusters must have more than 2 CKUs. | `number` | `0` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the environament you want to use. | `string` | n/a | yes |
| <a name="input_kafka_cluster_availability_zone"></a> [kafka\_cluster\_availability\_zone](#input\_kafka\_cluster\_availability\_zone) | The availability zone configuration of the Kafka cluster. Accepted values are: SINGLE\_ZONE and MULTI\_ZONE. | `string` | `"SINGLE_ZONE"` | no |
| <a name="input_kafka_cluster_cloud_provider"></a> [kafka\_cluster\_cloud\_provider](#input\_kafka\_cluster\_cloud\_provider) | The cloud service provider that runs the Kafka cluster. The accepted values are: GCP, AWS and Azure. | `string` | `"GCP"` | no |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | The name of the Kafka cluster. | `string` | n/a | yes |
| <a name="input_kafka_cluster_region"></a> [kafka\_cluster\_region](#input\_kafka\_cluster\_region) | The configuration region of the Kafka cluster. | `string` | n/a | yes |
| <a name="input_kafka_cluster_type"></a> [kafka\_cluster\_type](#input\_kafka\_cluster\_type) | The configuration of the Kafka cluster. | `string` | `"basic"` | no |
| <a name="input_schema_registry_cloud"></a> [schema\_registry\_cloud](#input\_schema\_registry\_cloud) | Cloud Provider for Schema Registry | `string` | `"GCP"` | no |
| <a name="input_schema_registry_package"></a> [schema\_registry\_package](#input\_schema\_registry\_package) | he type of the billing package. Accepted values are: ESSENTIALS and ADVANCED. | `string` | `"ESSENTIALS"` | no |
| <a name="input_schema_registry_region"></a> [schema\_registry\_region](#input\_schema\_registry\_region) | Region for Schema Registry | `string` | `"europe-west3"` | no |
| <a name="input_services_acls"></a> [services\_acls](#input\_services\_acls) | The variable that defines all the services (API Keys) needed to create the restricted access on the ACLs. | <pre>list(object({<br>    name           = string<br>    readTopics     = optional(list(string), [])<br>    writeTopics    = optional(list(string), [])<br>    clusterAccess  = optional(list(string), [])<br>    consumerGroups = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | This helps to create a Topic resource along with the specific settings. | <pre>map(object({<br>    partitions_count = number<br>    config           = map(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_admin_api_version"></a> [cluster\_admin\_api\_version](#output\_cluster\_admin\_api\_version) | n/a |
| <a name="output_cluster_admin_id"></a> [cluster\_admin\_id](#output\_cluster\_admin\_id) | n/a |
| <a name="output_cluster_admin_kind"></a> [cluster\_admin\_kind](#output\_cluster\_admin\_kind) | n/a |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | n/a |
| <a name="output_kafka_cluster_bootstrap_endpoint"></a> [kafka\_cluster\_bootstrap\_endpoint](#output\_kafka\_cluster\_bootstrap\_endpoint) | The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster. |
| <a name="output_kafka_cluster_rest_endpoint"></a> [kafka\_cluster\_rest\_endpoint](#output\_kafka\_cluster\_rest\_endpoint) | The REST endpoint of the Kafka cluster. |
| <a name="output_schema_registry_api_key_id"></a> [schema\_registry\_api\_key\_id](#output\_schema\_registry\_api\_key\_id) | Kafka Schema API key ID |
| <a name="output_schema_registry_api_key_secret"></a> [schema\_registry\_api\_key\_secret](#output\_schema\_registry\_api\_key\_secret) | Kafka Schema API key Secret |
| <a name="output_schema_registry_rest_endpoint"></a> [schema\_registry\_rest\_endpoint](#output\_schema\_registry\_rest\_endpoint) | Kafka Schema Registry Rest Endpoint |
| <a name="output_services_keys_list"></a> [services\_keys\_list](#output\_services\_keys\_list) | List with paired objects for service keys |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
