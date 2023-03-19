data "aws_ami" "debezium" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debezium*"]
  }

  owners = [var.aws_account_id]
}

resource "aws_instance" "debezium" {
  ami                     = data.aws_ami.debezium.id
  instance_type           = "t3.small"
  key_name                = aws_key_pair.key.key_name
  subnet_id               = aws_subnet.subnet-1a.id
  vpc_security_group_ids  = [aws_security_group.debezium.id]
  disable_api_termination = true

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "10"

    tags = {
      Name = var.default_tag
    }
  }

  tags = {
    Name = var.default_tag
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  user_data = templatefile("files/user_data.sh", {
    brokers           = aws_msk_cluster.kafka.bootstrap_brokers
    database_host     = aws_db_instance.default.address
    database_username = aws_db_instance.default.username
    database_password = random_password.password.result
    database_schema   = "sample_database"
  })

}
