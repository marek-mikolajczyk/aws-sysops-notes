resource "aws_s3_bucket" "webserver-dev" {
  bucket = "webserver-dev"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "webserver-dev"
    Environment = "Dev"
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}
