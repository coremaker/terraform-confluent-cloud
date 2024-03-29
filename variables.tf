# ENVIRONMENT
variable "environment_name" {
  type        = string
  description = "The name of the environament you want to use."
}

# CLUSTER
variable "kafka_cluster_type" {
  type        = string
  default     = "basic"
  description = "The configuration of the Kafka cluster."
}

variable "kafka_cluster_name" {
  type        = string
  description = "The name of the Kafka cluster."
}

variable "kafka_cluster_availability_zone" {
  type        = string
  default     = "SINGLE_ZONE"
  description = "The availability zone configuration of the Kafka cluster. Accepted values are: SINGLE_ZONE and MULTI_ZONE."
}

variable "kafka_cluster_cloud_provider" {
  type        = string
  default     = "GCP"
  description = "The cloud service provider that runs the Kafka cluster. The accepted values are: GCP, AWS and Azure."
}

variable "kafka_cluster_region" {
  type        = string
  description = "The configuration region of the Kafka cluster."
}

variable "dedicated_cluster_cku" {
  type        = number
  default     = 0
  description = "The number of Confluent Kafka Units for Dedicated cluster types. The minimum number of CKUs for SINGLE_ZONE dedicated clusters is 1 whereas MULTI_ZONE dedicated clusters must have more than 2 CKUs."
}

# TOPICS
variable "topics" {
  type = map(object({
    partitions_count = number
    config           = map(string)
  }))
  default     = {}
  description = "This helps to create a Topic resource along with the specific settings."
}

# API Keys
variable "services_acls" {
  type = list(object({
    name                   = string
    readTopics             = optional(list(string), [])
    writeTopics            = optional(list(string), [])
    clusterAccess          = optional(list(string), [])
    consumerGroups         = optional(list(string), [])
    prefixedConsumerGroups = optional(list(string), [])
  }))
  default     = []
  description = "The variable that defines all the services (API Keys) needed to create the restricted access on the ACLs."
}

# SCHEMA REGISTRY
variable "schema_registry_cloud" {
  type        = string
  default     = "GCP"
  description = "Cloud Provider for Schema Registry"
}

variable "schema_registry_region" {
  type        = string
  default     = "europe-west3"
  description = "Region for Schema Registry"
}

variable "schema_registry_package" {
  type        = string
  default     = "ESSENTIALS"
  description = "he type of the billing package. Accepted values are: ESSENTIALS and ADVANCED."
}
