resource "aws_security_group_rule" "debezium_0" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.debezium.id
  description       = "Debezium egress"
}

resource "aws_security_group_rule" "debezium_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
  security_group_id = aws_security_group.debezium.id
  description       = "SSH access"
}
