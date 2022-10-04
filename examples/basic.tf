module "basic" {
  source = "../"

  environment_name     = "dev"
  kafka_cluster_name   = "DEV"
  kafka_cluster_region = "northamerica-northeast1"
  topics = {
    users = {
      partitions_count = 4
      config = {
        "cleanup.policy"    = "compact"
        "max.message.bytes" = "12345"
        "retention.ms"      = "67890"
      }
    }
    accounts = {
      partitions_count = 5
      config = {
        "cleanup.policy"    = "compact"
        "max.message.bytes" = "10000"
        "retention.ms"      = "60000"
      }
    }
    payments = {
      partitions_count = 6
      config = {
        "cleanup.policy"    = "compact"
        "max.message.bytes" = "10000"
        "retention.ms"      = "60001"
      }
    }
    reports = {
      partitions_count = 8
      config = {
        "cleanup.policy"    = "compact"
        "max.message.bytes" = "10330"
        "retention.ms"      = "69900"
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
