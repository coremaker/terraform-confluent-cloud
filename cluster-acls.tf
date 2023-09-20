locals {
  cluster_operation_access = flatten([
    for service in var.services_acls : [
      for operation in service.clusterAccess : {
        operation = operation
        name      = service.name
        rsName    = join("_", [service.name, operation])
      }
    ]
  ])
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
