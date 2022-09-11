variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "default_tag" {
  type    = string
  default = "rds_debezium_msk"
}

variable "my_ip_address" {
  type = string
}

variable "database_name" {
  type    = string
  default = "my-database"
}

variable "aws_account_id" {
  type = string
}