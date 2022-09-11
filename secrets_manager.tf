# RDS secrets
resource "aws_secretsmanager_secret" "example" {
  kms_key_id              = aws_kms_key.secrets_manager.key_id
  name                    = "rds_admin_password"
  description             = "RDS Admin password"
  recovery_window_in_days = 0

  tags = {
    Name = var.default_tag
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = random_password.password.result
}

# MSK secrets
resource "aws_secretsmanager_secret" "msk" {
  kms_key_id              = aws_kms_key.kafka_key.key_id
  name                    = "AmazonMSK_kafka_user"
  description             = "MSK access user"
  recovery_window_in_days = 0

  tags = {
    Name = var.default_tag
  }
}

# MSK password
resource "random_password" "msk_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "msk" {
  secret_id = aws_secretsmanager_secret.msk.id
  secret_string = jsonencode({
    "username" = "msk_user",
    "password" = random_password.msk_password.result
  })
}
