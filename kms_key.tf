# KMS key used by Secrets Manager for RDS
resource "aws_kms_key" "secrets_manager" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}

resource "aws_kms_key" "kafka_key" {
  description             = "Kafka key"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}
