resource "aws_security_group" "kafka" {
  name        = "kafka"
  description = "Kafka cluster access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = var.default_tag
  }
}

resource "aws_security_group" "debezium" {
  name        = "debezium"
  description = "debezium instance"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = var.default_tag
  }
}