variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

/*
variable "instance_name" {
  type = list(string)
  default = ["", "bbb", "ccc"]
}


variable "" {
  type = list(string)
  default = ["", "us-east-1b", "us-east-1c"]
}
*/

variable instance_list {

  type = list(object({
    instance_name = string
    instance_az = string
  }))

  default = [
    {
      instance_name   =  "aaa"
      instance_az     =  "us-east-1a"
    },
    {
      instance_name   =  "bbb"
      instance_az     =  "us-east-1b"
    },
        {
      instance_name   =  "ccc"
      instance_az     =  "us-east-1c"
    }
  ]
}