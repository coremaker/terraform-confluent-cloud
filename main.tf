locals {
  iam_services = {
    for service in var.services_acls :
    service.name => service
  }
}

resource "confluent_environment" "main" {
  display_name = var.environment_name
}

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
    }
  }

  environment {
    id = confluent_environment.main.id
  }
}

resource "confluent_service_account" "cluster_admin" {
  display_name = "${confluent_kafka_cluster.main.display_name}-manager"
  description  = "Service account to manage 'main' Kafka cluster"
}

resource "confluent_role_binding" "cluster_admin" {
  principal   = "User:${confluent_service_account.cluster_admin.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.main.rbac_crn
}

resource "confluent_api_key" "cluster_admin_key" {
  display_name = "${confluent_kafka_cluster.main.display_name}-key"
  description  = "Kafka API Key that is owned by 'cluster_admin' service account"
  owner {
    id          = confluent_service_account.cluster_admin.id
    api_version = confluent_service_account.cluster_admin.api_version
    kind        = confluent_service_account.cluster_admin.kind
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
    confluent_role_binding.cluster_admin
  ]
}

### Service accounts
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
