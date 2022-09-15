# Create envinroment resource
resource "confluent_environment" "main" {
  display_name = var.confluent_environment_name
}

# Create cluster resource
resource "confluent_kafka_cluster" "main" {
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
resource "confluent_service_account" "app-manager" {
  display_name = "${confluent_kafka_cluster.main.display_name}-manager"
  description  = "Service account to manage 'main' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.main.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "${confluent_kafka_cluster.main.display_name}-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.main.id
    api_version = confluent_kafka_cluster.main.api_version
    kind        = confluent_kafka_cluster.main.kind

    environment {
      id = confluent_environment.main.id
    }
  }

    depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

# Create Topics

resource "confluent_kafka_topic" "main" {
  for_each = var.topics
  topic_name = each.key

  kafka_cluster {
    id = confluent_kafka_cluster.main.id
  }

  rest_endpoint = confluent_kafka_cluster.main.rest_endpoint
  partitions_count = each.value["partitions_count"]
  config = each.value["config"]

  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

# Create Cluster API keys with restricted access

# Read Access
resource "confluent_service_account" "first-key" {
  display_name = "${confluent_kafka_cluster.main.display_name}-first-key"
  description  = "Service account to manage 'main' Kafka cluster"
}
resource "confluent_kafka_acl" "first-key-on-topic" {
  for_each = toset(var.resource_name_list_for_first_key)

  kafka_cluster {
    id = confluent_kafka_cluster.main.id
  }

  resource_type = each.value["resource_type"]
  resource_name = each.key
  pattern_type  = each.value["pattern_type"]
  principal     = "User:${confluent_service_account.first-key.id}"
  host          = each.value["host"]
  operation     = each.value["operation"]
  permission    = each.value["permission"]
  rest_endpoint = confluent_kafka_cluster.main.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
  depends_on = [
    confluent_service_account.app-manager,
    confluent_api_key.app-manager-kafka-api-key
  ]
}

# Write Access
# resource "confluent_service_account" "app-write-manager" {
#   display_name = "${confluent_kafka_cluster.main.display_name}-write-manager"
#   description  = "Service account to manage 'main' Kafka cluster"
# }

# resource "confluent_kafka_acl" "app-write-manager-on-topic" {
#   for_each= toset(var.resource_name_list)

#   kafka_cluster {
#     id = confluent_kafka_cluster.main.id
#   }

#   resource_type = each.value["resource_type"]
#   resource_name = each.key
#   pattern_type  = each.value["pattern_type"]
#   principal     = "User:${confluent_service_account.app-write-manager.id}"
#   host          = each.value["host"]
#   operation     = each.value["operation"]
#   permission    = each.value["permission"]
#   rest_endpoint = confluent_kafka_cluster.main.rest_endpoint
#   credentials {
#     key    = confluent_api_key.app-manager-kafka-api-key.id
#     secret = confluent_api_key.app-manager-kafka-api-key.secret
#   }
#   depends_on = [
#     confluent_service_account.app-manager,
#     confluent_api_key.app-manager-kafka-api-key
#   ]
# }
