terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "best_deals_key" {
  key_name = "best-deals-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "my_security_group" {
  import {
    id = "sg-03e0d8c0756dad07e"
  }
}

resource "aws_instance" "best_deals_website" {
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name = aws_key_pair.best_deals_key.key_name
  security_groups = ["sg-03e0d8c0756dad07e"]
  tags = {
    Name = "best-deals"
  }
}

output "public_ip" {
  value = aws_instance.best_deals_website.public_ip
}
