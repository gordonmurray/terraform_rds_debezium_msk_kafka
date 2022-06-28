variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "default_tag" {
  type    = string
  default = "rds_debezium_msk"
}
