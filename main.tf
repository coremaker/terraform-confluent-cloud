# Create envinroment resource
resource "confluent_environment" "main" {
  display_name = var.confluent_environment_name
}

# Create cluster resource
resource "confluent_kafka_cluster" "main" {
  count = var.create_cluster ? 1 : 0
  
  display_name = var.kafka_cluster_name
  availability = var.kafka_cluster_availability_zone
  cloud        = var.kafka_cluster_cloud_provider
  region       = var.kafka_cluster_region

  dynamic "basic" {
    for_each = var.kafka_cluster_type == "basic" ? [1] : []
    content {}
  }

  dynamic "standard" {
    for_each = var.kafka_cluster_type == "standard" ? [1] : []
    content {}
  }

  dynamic "dedicated" {
    for_each = var.kafka_cluster_type == "dedicated" ? [1] : []
    content {
        cku = var.dedicated_cluster_cku
        encryption_key = var.dedicated_encryption_key
    }
  }

  environment {
    id = confluent_environment.main.id
  }
}

# Create service account
# resource "confluent_service_account" "app-manager" {
#   display_name = "app-manager-service-account"
#   description  = "Service account to manage 'test' Kafka cluster"
# }

# resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
#   principal   = "User:${confluent_service_account.app-manager.id}"
#   role_name   = "CloudClusterAdmin"
#   crn_pattern = confluent_kafka_cluster.test_cluster[0].rbac_crn
# }

# resource "confluent_api_key" "app-manager-kafka-api-key" {
#   # for_each = var.services
#   display_name = "api_key_name"
#   description  = "Kafka API Key that is owned by 'app-manager' service account"
#   owner {
#     id          = confluent_service_account.app-manager.id
#     api_version = confluent_service_account.app-manager.api_version
#     kind        = confluent_service_account.app-manager.kind
#   }

#   managed_resource {
#     id          = confluent_kafka_cluster.test_cluster[0].id
#     api_version = confluent_kafka_cluster.test_cluster[0].api_version
#     kind        = confluent_kafka_cluster.test_cluster[0].kind

#     environment {
#       id = confluent_environment.test_environment.id
#     }
#   }

#     depends_on = [
#     confluent_role_binding.app-manager-kafka-cluster-admin
#   ]
# }

# # Create Topics
# resource "confluent_kafka_topic" "test_topic" {
#   kafka_cluster {
#     id = confluent_kafka_cluster.test_cluster[0].id
#   }

#   rest_endpoint = confluent_kafka_cluster.test_cluster[0].rest_endpoint
#   for_each = var.topics
#   topic_name = each.key
#   partitions_count = each.value["partitions_count"]
#   config = each.value["config"]

#   credentials {
#     key    = confluent_api_key.app-manager-kafka-api-key.id
#     secret = confluent_api_key.app-manager-kafka-api-key.secret
#   }

#   lifecycle {
#     prevent_destroy = false
#   }
# }

# Create Cluster API keys with restricted access

# resource "confluent_kafka_acl" "app-producer-read-on-topic" {
#   kafka_cluster {
#     id = confluent_kafka_cluster.test_cluster[0].id
#   }
#   for_each = var.services
#   resource_type = "TOPIC"
#   resource_name = confluent_kafka_topic.test_topic.topic_name
#   pattern_type  = each.value["pattern_type"]
#   principal     = "User:${confluent_service_account.app-manager.id}"
#   host          = each.value["host"]
#   operation     = each.value["operation"]
#   permission    = each.value["permission"]
#   rest_endpoint = confluent_kafka_cluster.test_cluster[0].rest_endpoint
#   credentials {
#     key    = confluent_api_key.app-manager-kafka-api-key.id
#     secret = confluent_api_key.app-manager-kafka-api-key.secret
#   }
# }

# resource "confluent_kafka_acl" "app-producer-write-on-topic" {
#   kafka_cluster {
#     id = confluent_kafka_cluster.test_cluster.id
#   }
#   for_each = var.services
#   resource_type = "TOPIC"
#   resource_name = confluent_kafka_topic.test_topic.topic_name
#   pattern_type  = each.value["pattern_type"]
#   principal     = "User:${confluent_service_account.app-manager.id}"
#   host          = each.value["host"]
#   operation     = each.value["operation"]
#   permission    = each.value["permission"]
#   rest_endpoint = confluent_kafka_cluster.test_cluster[0].rest_endpoint
#   credentials {
#     key    = confluent_api_key.app-manager-kafka-api-key.id
#     secret = confluent_api_key.app-manager-kafka-api-key.secret
#   }
# }




