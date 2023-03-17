output "rds_host" {
  value = aws_db_instance.default.address
}

output "rds_username" {
  value = aws_db_instance.default.username
}

output "rds_password" {
  value     = aws_db_instance.default.password
  sensitive = true
}

output "debezium_instance_ip" {
  value = aws_instance.debezium.public_ip
}

output "kafka" {
  value = aws_msk_cluster.kafka.bootstrap_brokers
}

