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
  identifier              = "my-database"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mariadb"
  engine_version          = "10.4.21"
  instance_class          = "db.t4g.micro"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  username                = "Admin"
  password                = random_password.password.result
  parameter_group_name    = "default.mariadb10.4"
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 3

  tags = {
    Name = var.default_tag
  }
}
