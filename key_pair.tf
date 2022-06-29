resource "aws_key_pair" "key" {
  key_name   = "debezium_instance"
  public_key = file("~/.ssh/id_rsa.pub")
}