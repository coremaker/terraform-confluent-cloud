locals {
  iam_services = {
    for service in var.services_acls :
    service.name => service
  }
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
