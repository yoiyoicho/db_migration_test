provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_s3_bucket" "s3_bucket_for_db_migration" {
  bucket = "yoshino-minako-migrations"
}

resource "aws_iam_policy" "github_actions_migration_policy" {
  name        = "github-actions-migration-policy"
  path        = "/"
  description = ""

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Sid" : "AllowS3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::yoshino-minako-migrations",
          "arn:aws:s3:::yoshino-minako-migrations/*"
        ]
      },
    ]
  })
}