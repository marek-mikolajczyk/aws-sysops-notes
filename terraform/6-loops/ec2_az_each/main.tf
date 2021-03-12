resource "aws_instance" "example" {

    for_each =   { for instance in var.instance_list : instance.instance_name => instance }


    ami = "ami-042e8287309f5df03"
    instance_type = "t2.micro"
    security_groups = [upper(each.value.instance_name)]
    availability_zone = each.value.instance_az
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p ${var.server_port} & 
        EOF

    
    tags = {
        Name = each.value.instance_name
    }

}


resource "aws_security_group" "instance2" {

  for_each =   { for instance in var.instance_list : instance.instance_name => instance }

  name = upper(each.value.instance_name)
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


