terraform {
	backend "s3" {
	bucket = "terraform-up-and-running-state1234"
	key = "workspaces-example-dev/terraform.tfstate"
	region = "us-east-1"
	encrypt = true
	}
}

resource "aws_instance" "example_dev" {
	ami = "ami-042e8287309f5df03"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance-dev.id]

/*	user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World DEV   ${aws_security_group.instance-dev.id} " > index.html
		nohup busybox httpd -f -p ${var.server_port} &
		EOF
*/
	user_data	= file("user-data.sh")

	tags = {
		Name = "terraform-example-dev"
	}



}

resource "aws_security_group" "instance-dev" {
	name = "terraform-example-instance-dev"
	ingress {
		from_port = var.server_port
		to_port = var.server_port
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}


variable "server_port" {
	description = "The port the server will use for HTTP requests"
	type = number
	default = 8080
}


output "public_ip" {
	value = aws_instance.example_dev.public_ip
	description = "The public IP address of the web server"
}
