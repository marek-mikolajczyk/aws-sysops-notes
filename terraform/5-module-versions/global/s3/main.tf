provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "log_bucket" {

  bucket = var.s3_main_bucket
  acl    = "log-delivery-write"
}
