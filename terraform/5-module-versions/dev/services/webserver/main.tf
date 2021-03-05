provider "aws" {
	region = "us-east-1"
}


terraform {
	backend "s3" {
	bucket = "webserver-dev"
	key = "TF/terraform.tfstate"
	region = "us-east-1"
	encrypt = true
	}
}



module "webserver_cluster" {
	source = "../../../modules/services/webserver/"

	server_port	= 8080
	server_env	= "DEV"
}

