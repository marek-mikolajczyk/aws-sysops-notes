resource "aws_iam_user" "example" {
	count = 3
	name = "neo${count.index}"
}


variable "user_list" {
	type = list
	default = ["tom", "jerry"]
}

resource "aws_iam_user" "example2" {
        count = length(var.user_list)
        name = var.user_list[count.index]
}


resource "aws_iam_user" "example3" {
        for_each = toset(var.user_list)
        name = each.value
}