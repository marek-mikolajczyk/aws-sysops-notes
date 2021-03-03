provider "aws" {
	region = "us-east-1"
}
/*
	resource "aws_s3_bucket" "terraform_state" {
	bucket = "terraform-up-and-running-state123"
	lifecycle {
		prevent_destroy = true
		
	}

	versioning {
			enabled = true
	}

	server_side_encryption_configuration {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm = "AES256"
				}
			}
	}
}
*/