resource "aws_s3_bucket" "webserver-prod" {
  bucket = "webserver-prod"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "webserver-prod"
    Environment = "prod"
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}
