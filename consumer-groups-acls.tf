locals {
  consumer_group_access = flatten([
    for service in var.services_acls : [
      for consumer in service.consumerGroups : {
        consumer = consumer
        name     = service.name
        rsName   = join("_", [service.name, consumer])
      }
    ]
  ])

  prefixed_consumer_group_access = flatten([
    for service in var.services_acls : [
      for consumer in service.prefixedConsumerGroups : {
        consumer = consumer
        name     = service.name
        rsName   = join("_", [service.name, consumer])
      }
    ]
  ])
}

### LITERAL CONSUMER GROUPS
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

### PREFIXED CONSUMER GROUPS
resource "confluent_kafka_acl" "prefixed_consumer_group_read" {
  for_each = { for i in local.prefixed_consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "PREFIXED"
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

resource "confluent_kafka_acl" "prefixed_consumer_group_write" {
  for_each = { for i in local.prefixed_consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "PREFIXED"
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

resource "confluent_kafka_acl" "prefixed_consumer_group_describe" {
  for_each = { for i in local.prefixed_consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "PREFIXED"
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

resource "confluent_kafka_acl" "prefixed_consumer_group_delete" {
  for_each = { for i in local.prefixed_consumer_group_access : i["rsName"] => i }

  resource_type = "GROUP"
  resource_name = each.value["consumer"]
  pattern_type  = "PREFIXED"
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
