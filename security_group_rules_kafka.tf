resource "aws_security_group_rule" "kafka_0" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.debezium.id
  security_group_id        = aws_security_group.kafka.id
  description              = "Kafka egress"
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

resource "aws_security_group_rule" "kafka_2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  security_group_id        = aws_security_group.kafka.id
  source_security_group_id = aws_security_group.debezium.id
  description              = "Allow Debezium to talk to the brokers"
}
