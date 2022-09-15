# ENVIRONMENT
variable "confluent_environment_name" {
    type = string
    description = "The name of the environament you want to use"
}

# CLUSTER
variable "kafka_cluster_type" {
    type = string
    default = "basic"
    description = "The configuration of the Kafka cluster"
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

variable "kafka_cluster_cloud_provider" {
    type = string
    default = "GCP"
    description = "The cloud service provider that runs the Kafka cluster. The accepted values are: GCP, AWS and Azure"
}

variable "kafka_cluster_region" {
    type = string
    default = "us-east1"
    description = "The configuration region of the Kafka cluster"
}

variable "dedicated_cluster_cku" {
    type = number
    default = 0
    description = "The number of Confluent Kafka Units for Dedicated cluster types. The minimum number of CKUs for SINGLE_ZONE dedicated clusters is 1 whereas MULTI_ZONE dedicated clusters must have more than 2 CKUs"
}

variable "dedicated_encryption_key" {
    type = string
    default = ""
    description = "The ID of the encryption key that is used to encrypt the data in the Kafka cluster"
}

# TOPICS
variable "topics" {
    type = map(object({
        partitions_count = number
        config = map(string)
    }))
    default = {}
    description = "This helps to create a Topic resource along with the specific settings"
}

# ACLs
variable "resource_name_list_for_first_key" {
    type = any
    default = [{}]
    description = ""
}

# variable "resource_name_list_for_2nd_key" {
#     type = map(string({
#         resource_type = string
#         pattern_type = string
#         principal = string
#         host = string
#         operation = string
#         permission = string
#     }))
#     default = {}
#     description = ""
# }
