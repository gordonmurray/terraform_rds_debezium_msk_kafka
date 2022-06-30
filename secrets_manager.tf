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