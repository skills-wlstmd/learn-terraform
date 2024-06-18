terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }

  backend "s3" {
    bucket = "tf-backend-wlstmd"
    key = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "main_vpc" {
  source   = "./custom_vpc"
  env      = terraform.workspace
}

resource "aws_s3_bucket" "tf_backend" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = "tf-backend-wlstmd"

  versioning {
    enabled = true
  }
  
  tags = {
    Name = "tf_backend"
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_owc" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count = terraform.workspace == "default" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.tf_backend_owc]
  bucket = aws_s3_bucket.tf_backend[0].id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "versioning_backend" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}