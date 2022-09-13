# ENVIRONMENT
variable "confluent_environment_name" {
    type = string
    description = "The name of the environament you want to use"
}

variable "confluent_environment_prevent_destroy" {
    type = bool
    default = false
    description = "This prevents Terraform from accidentally removing critical resources"
}

# CLUSTER
variable create_cluster {
    type = bool
    default = true
}

variable "kafka_cluster_type" {
    type = string
    default = "basic"
    description = ""
}

variable "kafka_cluster_name" {
    type = string
    description = "The name of the Kafka cluster"
}

variable "kafka_cluster_availability_zone" {
    type = string
    default = "SINGLE_ZONE"
    description = "The availability zone configuration of the Kafka cluster"
}

variable "kafka_cluster_region" {
    type = string
    default = "us-east1"
    description = "The configuration region of the Kafka cluster"
}

variable "kafka_cluster_prevent_destroy" {
    type = bool
    default = false
    description = "This prevents Terraform from accidentally removing critical resources"
}

variable "dedicated_cluster_cku" {
    type = number
    default = 2
    description = "The number of Confluent Kafka Units for Dedicated cluster types. The minimum number of CKUs for SINGLE_ZONE dedicated clusters is 1 whereas MULTI_ZONE dedicated clusters must have more than 2 CKUs"
}

variable "dedicated_cluster_encryption_key" {
    type = string
    default = 2
    description = ""
}

# TOPICS
# variable "topic_name" {
#     type = string
#     description = "The name of the kafka cluster topic name"
# }

# variable "partition_count" {
#     type = number
#     description = "The number of partitions to create in the topic, they are like physical directories"
# }

variable "kafka_topic_prevent_destroy" {
    type = bool
    default = false
    description = "This prevents Terraform from accidentally removing critical resources"
}

variable "topics" {
    type = map(object({
        partitions_count = number
        config = map(string)
    }))
    default = {}
}

# SERVICE ACCOUNT
# variable "service_account_name" {
#     type = string
#     description = "The name of the Confluent service account"
# }


# variable "services" {
#     type = any
#     default = {
#         payments = {
#             # api_key_name = "app-manager-kafka-api-key"
#             resource_name = ["", ""]
#             pattern_type = "LITERAL"
#             host = "*"
#             operation = "READ"
#             permission = "ALLOW"
#         }
#         reports = {
#             # api_key_name = "app-manager-kafka-api-key"
#             resource_name = ""
#             pattern_type = "LITERAL"
#             host = "*"
#             operation = "WRITE"
#             permission = "ALLOW"
#         }
#     }
# }
