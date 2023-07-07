# KMS key used by Secrets Manager for RDS
resource "aws_kms_key" "secrets_manager" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}

resource "aws_kms_key" "kafka_key" {
  description             = "Kafka key"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}

resource "aws_kms_key" "cloudwatch_key" {
  description             = "Cloudwatch key"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "cloudwatch-key-policy",
    "Statement" : [
      {
        "Sid" : "Allow CloudWatch Logs to use the KMS key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${var.aws_region}.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow key policy updates",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*" # Replace with your actual user or role ARN
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name = var.default_tag
  }
}


resource "aws_kms_key" "rds_key" {
  description             = "RDS key"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = var.default_tag
  }
}

