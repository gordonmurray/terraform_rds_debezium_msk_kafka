output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}

output "debezium_instance_ip" {
  value = aws_instance.debezium.public_ip
}
