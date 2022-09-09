resource "aws_security_group_rule" "rds_0" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
  description       = "RDS egress"
}

resource "aws_security_group_rule" "rds_1" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["${aws_eip.debezium.public_ip}/32"]
  security_group_id = aws_security_group.rds.id
  description       = "Allow Debezium in"
}
