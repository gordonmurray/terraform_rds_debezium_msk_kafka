# 3 x t3.small: $109.28/month
resource "aws_msk_cluster" "kafka" {
  cluster_name           = "kafka"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    client_subnets = [
      aws_subnet.subnet-1a.id,
      aws_subnet.subnet-1b.id,
      aws_subnet.subnet-1c.id,
    ]

    storage_info {
      ebs_storage_info {
        volume_size = 50
      }
    }

    security_groups = [
      aws_security_group.kafka.id,
    ]
  }

  configuration_info {
    arn      = aws_msk_configuration.configuration_debezium.arn
    revision = 1
  }

  client_authentication {
    sasl {
      iam   = false
      scram = true
    }
    unauthenticated = true

    tls {}
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kafka_key.arn

    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.kafka_broker_logs.name
      }

    }
  }

  tags = {
    Name = var.default_tag
  }
}

resource "aws_msk_configuration" "configuration_debezium" {
  kafka_versions = ["2.6.2"]
  name           = "kafka-configuration"
  description    = "MSK config, auto create topic for Debezium"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
zookeeper.connection.timeout.ms = 1000
PROPERTIES
}

resource "aws_msk_scram_secret_association" "example" {
  cluster_arn     = aws_msk_cluster.kafka.arn
  secret_arn_list = [aws_secretsmanager_secret.msk.arn]

  depends_on = [aws_secretsmanager_secret_version.msk]
}
