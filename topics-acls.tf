locals {
  read_topic_pairs = flatten([
    for service in var.services_acls : [
      for topic in service.readTopics : {
        topic  = topic
        name   = service.name
        rsName = join("_", [service.name, topic])
      }
    ]
  ])

  write_topic_pairs = flatten([
    for service in var.services_acls : [
      for topic in service.writeTopics : {
        topic  = topic
        name   = service.name
        rsName = join("_", [service.name, topic])
      }
    ]
  ])
}

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

### ACL for topics
resource "confluent_kafka_acl" "read" {
  for_each = { for i in local.read_topic_pairs : i["rsName"] => i }

  resource_type = "TOPIC"
  resource_name = each.value["topic"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[each.value["name"]].id}"
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
  for_each = { for i in local.write_topic_pairs : i["rsName"] => i }

  resource_type = "TOPIC"
  resource_name = each.value["topic"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[each.value["name"]].id}"
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
