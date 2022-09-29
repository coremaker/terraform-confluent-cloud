module "basic" {
  source = "../"

  environment_name     = "dev"
  kafka_cluster_name   = "DEV"
  kafka_cluster_region = "northamerica-northeast1"
  topics = {
    users = {
      partitions_count = 4
      config = {
        cleanup_policy    = "compact"
        max_message_bytes = "12345"
        retention_ms      = "67890"
      }
    }
    accounts = {
      partitions_count = 5
      config = {
        cleanup_policy    = "compact"
        max_message_bytes = "10000"
        retention_ms      = "60000"
      }
    }
    payments = {
      partitions_count = 6
      config = {
        cleanup_policy    = "compact"
        max_message_bytes = "10000"
        retention_ms      = "60001"
      }
    }
    reports = {
      partitions_count = 8
      config = {
        cleanup_policy    = "compact"
        max_message_bytes = "10330"
        retention_ms      = "69900"
      }
    }
  }
  services_acls = [
    {
      name        = "payments-service"
      readTopics  = ["users", "accounts"]
      writeTopics = ["payments"]
    },
    {
      name        = "reports-service"
      readTopics  = ["payments"]
      writeTopics = ["reports"]
    }
  ]
}
