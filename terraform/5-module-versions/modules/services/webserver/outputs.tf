output "instance_public_dns" {
	value = "instance public ip is ${aws_instance.instance-ec2.public_dns}"
	description = "The public IP address of the web server"
}


### The Ansible inventory file
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tpl",
    {
      servers = [aws_instance.instance-ec2.public_dns]
    }
  )
  filename = "hosts.cfg"
}