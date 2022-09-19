locals {
    read_topic_pairs = flatten([
        for service in var.services : [
            for topic in service.readTopics : {
                topic = topic
                name = service.name
            }
        ]
    ])
    write_topic_pairs = flatten([
        for service in var.services : [
            for topic in service.writeTopics : {
                topic = topic
                name = service.name
            }
        ]
    ])
    services = {
        for service in var.services :
        service.name => service
    }
}
    

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
resource "confluent_service_account" "main" {
  for_each = local.services

  display_name = each.key
  description  = "Service account used by the  ${each.key} service on ${confluent_kafka_cluster.main.display_name} cluster"
}

resource "confluent_api_key" "app-consumer-kafka-api-key" {
  for_each = local.services

  display_name = "${each.key}-key"
  description  = "Kafka API Key that is owned by ${each.key} service account"

  owner {
    id          = confluent_service_account.main[each.key].id
    api_version = confluent_service_account.main[each.key].api_version
    kind        = confluent_service_account.main[each.key].kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.main.id
    api_version = confluent_kafka_cluster.main.api_version
    kind        = confluent_kafka_cluster.main.kind

    environment {
      id = confluent_environment.main.id
    }
  }
}

resource "confluent_kafka_acl" "read" {
  for_each = toset(keys({for i, r in local.read_topic_pairs:  i => r}))

  resource_type = "TOPIC"
  resource_name = local.read_topic_pairs[each.value]["topic"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[local.read_topic_pairs[each.value]["name"]].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.main.rest_endpoint

  kafka_cluster {
    id = confluent_kafka_cluster.main.id
  }

  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "write" {
  for_each = toset(keys({for i, r in local.write_topic_pairs:  i => r}))

  resource_type = "TOPIC"
  resource_name = local.write_topic_pairs[each.value]["topic"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[local.write_topic_pairs[each.value]["name"]].id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.main.rest_endpoint

  kafka_cluster {
    id = confluent_kafka_cluster.main.id
  }

  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
