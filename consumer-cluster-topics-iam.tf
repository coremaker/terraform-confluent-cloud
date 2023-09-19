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

  iam_services = {
    for service in var.services_acls :
    service.name => service
  }

  cluster_operation_access = flatten([
    for service in var.services_acls : [
      for operation in service.clusterAccess : {
        operation = operation
        name      = service.name
        rsName    = join("_", [service.name, operation])
      }
    ]
  ])

  consumer_group_access = flatten([
    for service in var.services_acls : [
      for consumer in service.consumerGroups : {
        consumer = consumer
        name     = service.name
        rsName   = join("_", [service.name, consumer])
      }
    ]
  ])
}

resource "confluent_service_account" "main" {
  for_each = local.iam_services

  display_name = each.key
  description  = "Service account used by the ${each.key} service on ${confluent_kafka_cluster.main.display_name} cluster"
}

resource "confluent_api_key" "services_api_keys" {
  for_each = local.iam_services

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

resource "confluent_kafka_acl" "cluster_configs" {
  for_each = { for i in local.cluster_operation_access : i["rsName"] => i }

  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[each.value["name"]].id}"
  host          = "*"
  operation     = each.value["operation"]
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

resource "confluent_kafka_acl" "consumer_group_read" {
  for_each = { for i in local.consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
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

resource "confluent_kafka_acl" "consumer_group_write" {
  for_each = { for i in local.consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
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

resource "confluent_kafka_acl" "consumer_group_describe" {
  for_each = { for i in local.consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[each.value["name"]].id}"
  host          = "*"
  operation     = "DESCRIBE"
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

resource "confluent_kafka_acl" "consumer_group_delete" {
  for_each = { for i in local.consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.main[each.value["name"]].id}"
  host          = "*"
  operation     = "DELETE"
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
