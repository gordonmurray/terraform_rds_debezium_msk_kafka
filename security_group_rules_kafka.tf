resource "aws_security_group_rule" "kafka_0" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kafka.id
  description       = ""
}

resource "aws_security_group_rule" "kafka_1" {
  type              = "ingress"
  from_port         = 8083
  to_port           = 8083
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.kafka.id
  description       = "Self"
}
