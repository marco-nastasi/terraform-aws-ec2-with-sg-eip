terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "MyInstance" {
  ami               = "ami-0742b4e673072066f"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  security_groups = ["AllowHTTPFromSpecificCIDRRanges", "SSHSecurityGroup"]
  tags = {
    Name = "ExampleAppServerInstanceTF"
  }
}

resource "aws_security_group" "SSHSecurityGroup" {
  name = "SSHSecurityGroup"
  description = "Enable SSH access via port 22"
  ingress {
    description = "SSH from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSHSecurityGroup"
  }
}

resource "aws_security_group" "AllowHTTPFromSpecificCIDRRanges" {
  name = "AllowHTTPFromSpecificCIDRRanges"
  description = "allow connections from specified CIDR ranges"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["192.168.1.1/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "AllowHTTPFromSpecificCIDRRanges"
  }
}

resource "aws_eip" "elasticip" {
    instance = aws_instance.MyInstance.id
}
