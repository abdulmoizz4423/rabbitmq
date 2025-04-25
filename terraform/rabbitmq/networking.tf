data "aws_subnet" "main" {
  filter {
    name   = "tag:Name"
    values = ["second"]
  }
}

data "aws_subnet" "secondary" {
  filter {
    name   = "tag:Name"
    values = ["first"]
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}