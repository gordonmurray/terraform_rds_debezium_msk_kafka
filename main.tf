terraform {

  required_version = "1.4.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"

    }
  }

}

# Configure the AWS Provider
provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "gordonmurray"

  default_tags {
    tags = {
      Repo = "https://github.com/gordonmurray/terraform_rds_debezium_msk_kafka"
    }
  }
}
