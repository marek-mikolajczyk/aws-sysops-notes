output "instance_ip" {
	value = module.webserver_cluster
	description = "The public IP address of the web server"
}

/*
output "instance_name" {
	value = "terraform-example-${var.server_env}"
	description = "The name address of the web server"
}

output "instance_public_dns" {
	value = aws_instance.instance-ec2.public_dns
	description = "The public IP address of the web server"
}

*/