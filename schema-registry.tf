data "confluent_schema_registry_region" "main" {
  cloud   = var.schema_registry_cloud
  region  = var.schema_registry_region
  package = var.schema_registry_package
}

resource "confluent_schema_registry_cluster" "main" {
  package = data.confluent_schema_registry_region.main.package

  environment {
    id = confluent_environment.main.id
  }

  region {
    id = data.confluent_schema_registry_region.main.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_api_key" "manager_schema_registry_api_key" {
  display_name = "${var.environment_name}-manager-schema-registry-api-key"
  description  = "Schema Registry API Key that is owned by '${var.environment_name}-manager' service account"
  owner {
    id          = confluent_service_account.cluster_admin.id
    api_version = confluent_service_account.cluster_admin.api_version
    kind        = confluent_service_account.cluster_admin.kind
  }

  managed_resource {
    id          = confluent_schema_registry_cluster.main.id
    api_version = confluent_schema_registry_cluster.main.api_version
    kind        = confluent_schema_registry_cluster.main.kind

    environment {
      id = confluent_environment.main.id
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}