resource "aws_cloudwatch_log_group" "kafka_broker_logs" {
  name = "msk_broker_logs"

  retention_in_days = 1

  tags = {
    Name = var.default_tag
  }

      kms_key_id = aws_kms_key.cloudwatch_key.arn
}