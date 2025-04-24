provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "orbital-terraform-infra"
    key    = "rabbitmq"
    region = "us-east-1"
  }
}