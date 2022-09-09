output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}

output "debezium_instance_ip" {
  value = aws_instance.debezium.public_ip
}

output "kafka" {
  value = aws_msk_cluster.kafka.bootstrap_brokers
}

output "rds" {
  value = aws_db_instance.default.address
}