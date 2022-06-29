resource "aws_eip" "debezium" {
  vpc = true

  tags = {
    Name = var.default_tag
  }
}

resource "aws_eip_association" "debezium" {
  instance_id   = aws_instance.debezium.id
  allocation_id = aws_eip.debezium.id
}