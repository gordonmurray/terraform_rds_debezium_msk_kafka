resource "aws_security_group_rule" "rds_0" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "all"
  source_security_group_id = aws_security_group.debezium.id
  security_group_id        = aws_security_group.rds.id
  description              = "Allow egress to Debezium instance"
}

resource "aws_security_group_rule" "rds_1" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.debezium.id
  security_group_id        = aws_security_group.rds.id
  description              = "Allow ingress to Debezium instance"
}
