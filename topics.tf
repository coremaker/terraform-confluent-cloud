resource "confluent_kafka_topic" "main" {
  for_each   = var.topics
  topic_name = each.key

  kafka_cluster {
    id = confluent_kafka_cluster.main.id
  }

  rest_endpoint    = confluent_kafka_cluster.main.rest_endpoint
  partitions_count = each.value["partitions_count"]
  config           = each.value["config"]

  credentials {
    key    = confluent_api_key.cluster_admin_key.id
    secret = confluent_api_key.cluster_admin_key.secret
  }
}
