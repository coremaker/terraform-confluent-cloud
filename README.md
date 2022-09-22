[![Maintained by coremaker.io](https://img.shields.io/badge/maintained%20by-coremaker.io-green)](https://coremaker.io/)

# Terraform-confluent-cloud

This is a terraform module for Confluent Cloud provider which helps you build environments, clusters, topics and API Keys with restricted access on ACLs.  

# Examples

```terraform
module "kubernetes" {
  source = "github.com/coremaker/terraform-confluent-cloud.git"

  confluent_environment_name = "dev"
  kafka_cluster_name = "DEV"
  kafka_cluster_region = "us-east1"
  topics = {
    users = {
        partitions_count = 4
        config = {
            cleanup_policy    = "compact"
            max_message_bytes = "12345"
            retention_ms      = "67890"
        }
    }
    accounts = {
        partitions_count = 5
        config = {
            cleanup_policy    = "compact"
            max_message_bytes = "10000"
            retention_ms      = "60000"
        }
    }
    payments = {
        partitions_count = 6
        config = {
            cleanup_policy    = "compact"
            max_message_bytes = "10000"
            retention_ms      = "60001"
        }
    }
    reports = {
        partitions_count = 8
        config = {
            cleanup_policy    = "compact"
            max_message_bytes = "10330"
            retention_ms      = "69900"
        }
    }     
  }
    services = [
        {
            name = "payments-service"
            readTopics = ["users", "accounts"]
            writeTopics = ["payments"]
        },
        {
            name = "reports-service"
            readTopics = ["payments"]
            writeTopics = ["reports"]
        }
    ]
}
```

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
| [confluent_api_key.app_consumer_kafka_api_key](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/api_key) | resource |
| [confluent_api_key.app_manager_kafka_api_key](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/api_key) | resource |
| [confluent_environment.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/environment) | resource |
| [confluent_kafka_acl.read](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.write](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_acl) | resource |
| [confluent_kafka_cluster.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_cluster) | resource |
| [confluent_kafka_topic.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/kafka_topic) | resource |
| [confluent_role_binding.app_manager_kafka_cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/role_binding) | resource |
| [confluent_service_account.app_manager](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/service_account) | resource |
| [confluent_service_account.main](https://registry.terraform.io/providers/confluentinc/confluent/1.4.0/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_environment_name"></a> [confluent\_environment\_name](#input\_confluent\_environment\_name) | The name of the environament you want to use. | `string` | n/a | yes |
| <a name="input_dedicated_cluster_cku"></a> [dedicated\_cluster\_cku](#input\_dedicated\_cluster\_cku) | The number of Confluent Kafka Units for Dedicated cluster types. The minimum number of CKUs for SINGLE\_ZONE dedicated clusters is 1 whereas MULTI\_ZONE dedicated clusters must have more than 2 CKUs. | `number` | `0` | no |
| <a name="input_dedicated_encryption_key"></a> [dedicated\_encryption\_key](#input\_dedicated\_encryption\_key) | The ID of the encryption key that is used to encrypt the data in the Kafka cluster. | `string` | `""` | no |
| <a name="input_kafka_cluster_availability_zone"></a> [kafka\_cluster\_availability\_zone](#input\_kafka\_cluster\_availability\_zone) | The availability zone configuration of the Kafka cluster. | `string` | `"SINGLE_ZONE"` | no |
| <a name="input_kafka_cluster_cloud_provider"></a> [kafka\_cluster\_cloud\_provider](#input\_kafka\_cluster\_cloud\_provider) | The cloud service provider that runs the Kafka cluster. The accepted values are: GCP, AWS and Azure. | `string` | `"GCP"` | no |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | The name of the Kafka cluster. | `string` | n/a | yes |
| <a name="input_kafka_cluster_region"></a> [kafka\_cluster\_region](#input\_kafka\_cluster\_region) | The configuration region of the Kafka cluster. | `string` | `"us-east1"` | no |
| <a name="input_kafka_cluster_type"></a> [kafka\_cluster\_type](#input\_kafka\_cluster\_type) | The configuration of the Kafka cluster. | `string` | `"basic"` | no |
| <a name="input_services"></a> [services](#input\_services) | The variable that defines all the services(API Keys) needed to create the restricted access on the ACLs. | <pre>list(object({<br>    name        = string<br>    readTopics  = list(string)<br>    writeTopics = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | This helps to create a Topic resource along with the specific settings. | <pre>map(object({<br>    partitions_count = number<br>    config           = map(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
