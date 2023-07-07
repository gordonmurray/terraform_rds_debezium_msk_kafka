resource "random_password" "password" {
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "default" {
  name = "rds_subnet_group"
  subnet_ids = [
    aws_subnet.subnet-1a.id,
    aws_subnet.subnet-1b.id,
    aws_subnet.subnet-1c.id,
  ]

  tags = {
    Name = var.default_tag
  }
}

resource "aws_db_instance" "default" {
  identifier                   = var.database_name
  allocated_storage            = 20
  storage_type                 = "gp2"
  engine                       = "mariadb"
  engine_version               = "10.6.10"
  instance_class               = "db.t4g.micro"
  db_subnet_group_name         = aws_db_subnet_group.default.name
  username                     = "Admin"
  password                     = random_password.password.result
  parameter_group_name         = aws_db_parameter_group.default.id
  option_group_name            = aws_db_option_group.default.id
  skip_final_snapshot          = true
  publicly_accessible          = false
  multi_az                     = false
  storage_encrypted            = true
  backup_retention_period      = 3
  performance_insights_enabled = false
  vpc_security_group_ids       = [aws_security_group.rds.id]

  tags = {
    Name = var.default_tag
  }
}

resource "aws_db_option_group" "default" {
  name                     = "${var.database_name}-options"
  option_group_description = "${var.database_name} option group"
  engine_name              = "mariadb"
  major_engine_version     = "10.6"

  tags = {
    Name = var.default_tag
  }

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.database_name}-parameter-group"
  family      = "mariadb10.6"
  description = "${var.database_name} parameters"

  tags = {
    Name = var.default_tag
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "binlog_format"
    value = "row"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

}
