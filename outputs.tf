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