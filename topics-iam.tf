locals {
  read_topic_pairs = flatten([
    for service in var.services : [
      for topic in service.readTopics : {
        topic = topic
        name  = service.name
      }
    ]
  ])
  write_topic_pairs = flatten([
    for service in var.services : [
      for topic in service.writeTopics : {
        topic = topic
        name  = service.name
      }
    ]
  ])
  services = {
    for service in var.services :
    service.name => service
  }
}

resource "confluent_service_account" "main" {
  for_each = local.services

  display_name = each.key
  description  = "Service account used by the ${each.key} service on ${confluent_kafka_cluster.main.display_name} cluster"
}

resource "confluent_api_key" "app_consumer_kafka_api_key" {
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
  for_each = toset(keys({ for i, r in local.read_topic_pairs : i => r }))

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
    key    = confluent_api_key.cluster_admin_key.id
    secret = confluent_api_key.cluster_admin_key.secret
  }
}

resource "confluent_kafka_acl" "write" {
  for_each = toset(keys({ for i, r in local.write_topic_pairs : i => r }))

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
    key    = confluent_api_key.cluster_admin_key.id
    secret = confluent_api_key.cluster_admin_key.secret
  }
}
