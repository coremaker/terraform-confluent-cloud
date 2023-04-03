output "kafka_cluster_bootstrap_endpoint" {
  value       = confluent_kafka_cluster.main.bootstrap_endpoint
  sensitive   = true
  description = "The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster."
}

output "kafka_cluster_rest_endpoint" {
  value       = confluent_kafka_cluster.main.rest_endpoint
  sensitive   = true
  description = "The REST endpoint of the Kafka cluster."
}

output "services_keys_list" {
  value = [
    for key in confluent_api_key.services_api_keys : {
      name   = key.display_name
      id     = key.id
      secret = key.secret
    }
  ]
  sensitive   = true
  description = "List with paired objects for service keys"
}

output "environment_id" {
  value = confluent_environment.main.id
}

output "cluster_admin_id" {
  value = confluent_service_account.cluster_admin.id
}

output "cluster_admin_api_version" {
  value = confluent_service_account.cluster_admin.api_version
}

output "cluster_admin_kind" {
  value = confluent_service_account.cluster_admin.kind
}

# Schema Registry
output "schema_registry_api_key_id" {
  value       = confluent_api_key.manager_schema_registry_api_key.id
  sensitive   = true
  description = "Kafka Schema API key ID"
}

output "schema_registry_api_key_secret" {
  value       = confluent_api_key.manager_schema_registry_api_key.secret
  sensitive   = true
  description = "Kafka Schema API key Secret"
}

output "schema_registry_rest_endpoint" {
  value       = confluent_schema_registry_cluster.main.rest_endpoint
  sensitive   = true
  description = "Kafka Schema Registry Rest Endpoint"
}
