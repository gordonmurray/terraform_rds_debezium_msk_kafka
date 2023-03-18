resource "aws_security_group_rule" "debezium_0" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
  security_group_id = aws_security_group.debezium.id
  description       = "SSH egress"
}

resource "aws_security_group_rule" "debezium_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
  security_group_id = aws_security_group.debezium.id
  description       = "SSH ingress"
}

resource "aws_security_group_rule" "debezium_registry" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip_address}/32"]
  security_group_id = aws_security_group.debezium.id
  description       = "Schema registry UI access"
}

