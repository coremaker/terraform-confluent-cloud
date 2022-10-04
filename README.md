[![Maintained by coremaker.io](https://img.shields.io/badge/maintained%20by-coremaker.io-green)](https://coremaker.io/)

# Terraform-confluent-cloud

This is a terraform module for Confluent Cloud provider which helps you build environments, clusters, topics and API Keys with restricted access on ACLs.  

# Examples

Please check the examples directory where different Kafka clusters types are used.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | 1.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | 1.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.cluster_admin_key](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/api_key) | resource |
| [confluent_api_key.services_api_keys](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/api_key) | resource |
| [confluent_environment.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/environment) | resource |
| [confluent_kafka_acl.read](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.write](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_acl) | resource |
| [confluent_kafka_cluster.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_cluster) | resource |
| [confluent_kafka_topic.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_topic) | resource |
| [confluent_role_binding.cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/role_binding) | resource |
| [confluent_service_account.cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/service_account) | resource |
| [confluent_service_account.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/service_account) | resource |

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
| <a name="input_services_acls"></a> [services\_acls](#input\_services\_acls) | The variable that defines all the services (API Keys) needed to create the restricted access on the ACLs. | <pre>list(object({<br>    name        = string<br>    readTopics  = optional(list(string))<br>    writeTopics = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | This helps to create a Topic resource along with the specific settings. | <pre>map(object({<br>    partitions_count = number<br>    config           = map(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kafka_cluster_bootstrap_endpoint"></a> [kafka\_cluster\_bootstrap\_endpoint](#output\_kafka\_cluster\_bootstrap\_endpoint) | The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster. |
| <a name="output_kafka_cluster_rest_endpoint"></a> [kafka\_cluster\_rest\_endpoint](#output\_kafka\_cluster\_rest\_endpoint) | The REST endpoint of the Kafka cluster. |
| <a name="output_services_keys_list"></a> [services\_keys\_list](#output\_services\_keys\_list) | List with paired objects for service keys |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
